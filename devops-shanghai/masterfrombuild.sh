#!/bin/bash -v
## Install Dependency Soft
sudo apt-get update -y
sudo apt-get install -y git docker.io
sudo systemctl start docker

## Clone Containerization Repository
sudo git clone https://github.com/zbbkeepgoing/containerization.git /opt/containerization

## Build Jenkins Master Images
cd /opt/containerization/Jenkin/jenkins-master 
sudo docker build -t jenkins:master .

## Run Jenkins Master
cd ../
sudo bash jenkins_master_run.sh
