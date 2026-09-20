#!/bin/bash

set -e

echo "=========================================="
echo " EC2 Setup: Docker + MERN Project"
echo "=========================================="

# Update system
echo "[1/7] Updating system packages..."
sudo apt-get update -y
sudo apt-get upgrade -y

# Install required utilities
echo "[2/7] Installing required packages..."
sudo apt-get install -y \
    ca-certificates \
    curl \
    gnupg \
    git \
    unzip \
    jq

# Add Docker's official GPG key
echo "[3/7] Installing Docker repository..."

sudo install -m 0755 -d /etc/apt/keyrings

curl -fsSL https://download.docker.com/linux/ubuntu/gpg \
    | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

sudo chmod a+r /etc/apt/keyrings/docker.gpg

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" \
  | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update -y

# Install Docker Engine and Compose
echo "[4/7] Installing Docker Engine and Docker Compose..."

sudo apt-get install -y \
    docker-ce \
    docker-ce-cli \
    containerd.io \
    docker-buildx-plugin \
    docker-compose-plugin

# Enable Docker service
echo "[5/7] Starting Docker..."

sudo systemctl enable docker
sudo systemctl start docker

# Add current user to Docker group
sudo usermod -aG docker "$USER"

# Verify installations
echo "[6/7] Verifying installations..."

sudo docker --version
sudo docker compose version
git --version

# Create application directory
echo "[7/7] Creating application directory..."

mkdir -p "$HOME/apps"

echo ""
echo "=========================================="
echo " EC2 SETUP COMPLETED SUCCESSFULLY"
echo "=========================================="

echo ""
echo "IMPORTANT: Log out and log back in for Docker permissions:"
echo "exit"
echo "Then reconnect using SSH."

echo ""
echo "Next steps:"
echo "1. Clone your GitHub repository"
echo "2. Configure environment variables"
echo "3. Run docker compose up -d --build"