# Use an official Python runtime as a parent image
FROM nvcr.io/nvidia/pytorch:24.05-py3


# Set the working directory in the container
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . .

# Install system dependencies for CUDA and other tools
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        wget \
        build-essential \
        git \
    && rm -rf /var/lib/apt/lists/*

RUN pip install torch torchvision torchaudio 

# Install additional Python dependencies
RUN pip install packaging ninja wheel setuptools setuptools-scm flash-attn

# Clone and install FlashAttention from GitHub
RUN git clone https://github.com/Dao-AILab/flash-attention.git && \
    cd flash-attention/hopper && \
    python setup.py install

# Install project dependencies
RUN pip install -r requirements.txt

# Install Weights & Biases for experiment tracking
RUN pip install wandb

# Expose port 8000 (if needed for any web-based components)
EXPOSE 8001