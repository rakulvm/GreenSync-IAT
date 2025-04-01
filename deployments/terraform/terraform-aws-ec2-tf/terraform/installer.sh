#!/bin/bash

# JDK installation
sudo add-apt-repository ppa:openjdk-r/ppa -y
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


# Adding jenkins user to docker group
sudo usermod -aG docker jenkins

sudo id jenkins

echo 'Added Jenkins user to the Docker group'

# Host key verification

mkdir -p ~/var/lib/jenkins/.ssh

touch known_hosts

sudo -u jenkins ssh-keyscan -t rsa github.com >> /var/lib/jenkins/.ssh/known_hosts

echo 'Added RSA key to server (host key verification)'

sudo -u jenkins ssh-keyscan -t ed25519 github.com >> /var/lib/jenkins/.ssh/known_hosts

echo 'Added ED key for host key verification'

sudo chown -R jenkins:jenkins /var/lib/jenkins/.ssh/known_hosts
sudo chmod 755 /var/lib/jenkins/.ssh/known_hosts


# Add E-mail notification part

sudo mkdir -p /var/jenkins_home/init.groovy.d

sudo cd /var/jenkins_home/init.groovy.d

sudo touch mail-config.groovy

echo "import jenkins.model.*
import hudson.tasks.Mailer

// Set Jenkins admin email
def locationConfig = JenkinsLocationConfiguration.get()
locationConfig.setAdminAddress("rakulmanokaran@gmail.com")
locationConfig.save()

// Configure Mailer settings
def mailer = Jenkins.instance.getDescriptorByType(Mailer.DescriptorImpl.class)
mailer.setSmtpHost("smtp.gmail.com")
mailer.setSmtpPort("587")
mailer.setUseSsl(false)
mailer.setSmtpAuth("rakulvimalamanokaran@gmail.com", "grdg wpes erxy iqcp")
mailer.setReplyToAddress("rakulvimalamanokaran@gmail.com")
mailer.setCharset("UTF-8")
mailer.save()" > mail-config.groovy

chown -R jenkins:jenkins /var/jenkins_home/init.groovy.d
chmod 755 /var/jenkins_home/init.groovy.d/mail-config.groovy

# Adding Plugin installation part 

sudo touch plugins.groovy

echo "import jenkins.model.*
import hudson.PluginWrapper

def instance = Jenkins.getInstance()
def pm = instance.getPluginManager()
def uc = instance.getUpdateCenter()

def plugins = [
    "docker-plugin",             // Docker
    "docker-commons",            // Docker Commons
    "docker-workflow",           // Docker Pipeline
    "kubernetes",                // Kubernetes
    "kubernetes-client-api",     // Kubernetes Client API
    "kubernetes-cli",            // Kubernetes CLI
    "hashicorp-vault-plugin",    // HashiCorp Vault
    "vault-pipeline",            // HashiCorp Vault Pipeline
    "azure-keyvault",            // Azure Key Vault
    "sourcegear-vault",          // SourceGear Vault
    "aws-credentials"            // AWS Credentials
]

plugins.each { pluginId ->
    if (!pm.getPlugin(pluginId)) {
        def plugin = uc.getPlugin(pluginId)
        if (plugin) {
            println "Installing plugin: $pluginId"
            plugin.deploy()
        } else {
            println "Plugin not found in update center: $pluginId"
        }
    } else {
        println "Plugin already installed: $pluginId"
    }
}

instance.save()" > plugins.groovy

sudo chmod 755 /var/jenkins_home/init.groovy.d/plugins.groovy

sudo systemctl restart jenkins