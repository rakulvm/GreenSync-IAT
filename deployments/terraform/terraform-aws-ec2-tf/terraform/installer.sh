#!/bin/bash

# JDK installation
sudo apt update

sudo apt install openjdk-17-jre -y
sudo apt install zip -y

echo 'JDK successfully installed'

#Python3 installation

sudo apt install python3 -y

echo 'Python3 successfully installed'

# Jenkins installation

sudo wget -O /usr/share/keyrings/jenkins-keyring.asc \
  https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key

echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc]" \
  https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null

sudo apt-get update
sudo apt install jenkins -y

echo 'Jenkins installed successfully'

sudo usermod -aG docker jenkins

sudo id jenkins

sudo systemctl restart jenkins

echo 'Added Jenkins user to the Docker group'

# Docker installation

# Add Docker's official GPG key:
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update


sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y


echo 'Docker installed successfully'

# Install Docker Compose (Standalone)
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose


echo 'Docker Compose installed successfully'

sudo -u jenkins ssh-keyscan -t rsa github.com >> /var/lib/jenkins/.ssh/known_hosts

echo 'Added RSA key to server (host key verification)'

sudo -u jenkins ssh-keyscan -t ed25519 github.com >> /var/lib/jenkins/.ssh/known_hosts

echo 'Added ED key for host key verification'