FROM nvcr.io/nvidia/pytorch:23.10-py3

WORKDIR /workspace

# Install system dependencies before pip install
RUN apt-get update && apt-get install -y \
    ffmpeg \
    git \
    libsoxr-dev \
    libsndfile1 \
    && rm -rf /var/lib/apt/lists/*

# Copy requirements first
COPY requirements.txt .

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of the app
COPY . .

# Start RunPod serverless queue handler
CMD ["python", "server.py"]
