# Use a base image with PyTorch, CUDA, and Python pre-installed (for GPU support)
FROM runpod/pytorch:2.1.0-py3.10-cuda12.1-cudnn8-devel-ubuntu22.04

# Set working directory inside container
WORKDIR /workspace

# Install system dependencies needed by your Python packages (like ffmpeg)
RUN apt-get update && apt-get install -y ffmpeg git && rm -rf /var/lib/apt/lists/*

# Copy requirements.txt into the container
COPY requirements.txt .

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy all your source code files into the container
COPY . .

# Expose the port your FastAPI server will listen on
EXPOSE 8000

# Command to run your FastAPI server using Uvicorn
CMD ["uvicorn", "server:app", "--host", "0.0.0.0", "--port", "8000"]
