#!/bin/bash -v
## Install Dependency Soft
sudo apt-get update -y
sudo apt-get install -y git docker.io openjdk-8-jdk
sudo systemctl start docker

## Update Docker Configuration
sudo echo 'DOCKER_OPTS="-H tcp://0.0.0.0:2376 -H unix:///var/run/docker.sock"' >> /etc/default/docker 
sudo sed -i '/ExecStart/i\EnvironmentFile=-/etc/default/docker' /lib/systemd/system/docker.service
sudo sed -i '/containerd.sock/ s/$/ $DOCKER_OPTS/' /lib/systemd/system/docker.service

## Restart Docker
sudo systemctl daemon-reload
sudo systemctl restart docker

## Clone Containerization Repository
sudo git clone https://github.com/zbbkeepgoing/containerization.git /opt/containerization

## Build Jenkins Master Images
cd /opt/containerization/Jenkin

## Run Configuration For Slave
sudo bash jenkins_dockerconfig.sh

## Run Sonarqube
cd /opt/containerization/Sonarqube
sudo bash docker_run.sh
