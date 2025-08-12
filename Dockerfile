# GPU-ready PyTorch image with CUDA and cuDNN
FROM nvcr.io/nvidia/pytorch:23.10-py3

# Set working directory inside container
WORKDIR /workspace

# Install system dependencies for audio processing
RUN apt-get update && apt-get install -y \
    ffmpeg \
    git \
    && rm -rf /var/lib/apt/lists/*

# Copy requirements.txt first for better Docker caching
COPY requirements.txt .

# Install Python dependencies from requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Install extra dependencies required for Audiocraft and transformers audio
RUN pip install --no-cache-dir \
    transformers \
    sentencepiece \
    soxr

# Copy all project files into the container
COPY . .

# Set container start command (RunPod Queue handler)
CMD ["python", "server.py"]
