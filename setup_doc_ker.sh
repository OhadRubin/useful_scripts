#!/bin/bash

DOCKER_VERSION="24.0.7"
COMPOSE_VERSION="2.23.0"

# Check if Docker is already installed with desired version
if docker --version 2>/dev/null | grep -q "$DOCKER_VERSION"; then
    echo "Docker $DOCKER_VERSION is already installed"
    exit 0
fi

# Download and install Docker
TEMP_DIR=$(mktemp -d)
cd "$TEMP_DIR" || exit 1

wget "https://download.docker.com/linux/static/stable/x86_64/docker-${DOCKER_VERSION}.tgz"
tar xzvf "docker-${DOCKER_VERSION}.tgz"

# Stop Docker if running
sudo systemctl stop docker || true

# Install Docker binaries
sudo rm -f /usr/bin/{containerd,containerd-shim-runc-v2,ctr,docker,dockerd,docker-init,docker-proxy,runc}
sudo cp docker/* /usr/bin/

# Install Docker Compose
sudo curl -SL "https://github.com/docker/compose/releases/download/v${COMPOSE_VERSION}/docker-compose-linux-x86_64" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
sudo ln -sf /usr/local/bin/docker-compose /usr/bin/docker-compose

# Setup user and permissions
sudo usermod -aG docker "$USER"
mkdir -p "$HOME/.docker"
sudo chown "$USER":"$USER" "$HOME/.docker" -R

# Configure Docker daemon
sudo mkdir -p /etc/docker
sudo tee /etc/docker/daemon.json <<EOF
{
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "10m",
    "max-file": "3"
  }
}
EOF

# Setup systemd service
sudo tee /etc/systemd/system/docker.service <<EOF
[Unit]
Description=Docker Application Container Engine
After=network-online.target

[Service]
Type=notify
ExecStart=/usr/bin/dockerd
Restart=always
TimeoutSec=0

[Install]
WantedBy=multi-user.target
EOF

# Start Docker service
sudo systemctl daemon-reload
sudo systemctl enable docker
sudo systemctl start docker

# Cleanup
cd ..
rm -rf "$TEMP_DIR"

sudo groupadd docker
sudo usermod -aG docker $USER

echo "Docker installation completed"
