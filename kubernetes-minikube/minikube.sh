#!/bin/bash -v
## Install docker
sudo apt-get update -y
sudo apt-get install -y docker.io
sudo systemctl enable docker
sudo systemctl start docker

## Update Docker Configuration
sudo echo 'DOCKER_OPTS="-H tcp://0.0.0.0:2376 -H unix:///var/run/docker.sock"' >> /etc/default/docker 
sudo sed -i '/ExecStart/i\EnvironmentFile=-/etc/default/docker' /lib/systemd/system/docker.service
sudo sed -i '/containerd.sock/ s/$/ $DOCKER_OPTS/' /lib/systemd/system/docker.service

## Restart Docker
sudo systemctl daemon-reload
sudo systemctl restart docker

## Install kubectl
curl -LO https://storage.googleapis.com/kubernetes-release/release/v1.16.0/bin/linux/amd64/kubectl
chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin/kubectl


## Install minikube
curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64 \
  && chmod +x minikube
sudo mkdir -p /usr/local/bin/
sudo install minikube /usr/local/bin/
sudo minikube start --vm-driver=none  --image-mirror-country cn --image-repository registry.cn-hangzhou.aliyuncs.com/google_containers