#!/bin/bash -v
## Install Dependency Soft
sudo apt-get update -y
sudo apt-get install -y git docker.io openjdk-8-jdk
sudo systemctl enable docker
sudo systemctl start docker

## Pull the release image
sudo docker pull registry-vpc.cn-shanghai.aliyuncs.com/devopsimages/jenkinsmaster:latest
sudo docker tag registry-vpc.cn-shanghai.aliyuncs.com/devopsimages/jenkinsmaster:latest jenkinsmaster:latest
sudo docker pull registry-vpc.cn-shanghai.aliyuncs.com/devopsimages/jenkinsplugins:latest
sudo docker tag registry-vpc.cn-shanghai.aliyuncs.com/devopsimages/jenkinsplugins:latest jenkinsplugin:latest

## Clone Containerization Repository
sudo git clone https://github.com/zbbkeepgoing/containerization.git /opt/containerization

## Build Jenkins Master Images
cd /opt/containerization/Jenkin

## Run Jenkins Master
sudo bash jenkins_master_run.sh
