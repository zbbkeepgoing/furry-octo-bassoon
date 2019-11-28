variable "access_key" {
  default = "xxxxxxxxxxxxxxx"
}

variable "secret_key" {
  default = "xxxxxxxxxxxxxxxxx"
}

variable "region" {
  default = "cn-shanghai"
}

variable "instance_cpu" {
  default = "2"
}

variable "instance_memory" {
  default = "8"
}

variable "instance_type_family" {
  default = "ecs.g6"
}

variable "vpc_cidr" {
  default = "192.168.0.0/16"
}


variable "k8s-name" {
  default = "hi-devopsk8s"
}


variable "k8s-password" {
  default = "xxxxxxxxxx"
}

variable "worker_number" {
  default = 2
}

variable "pod-cidr" {
  default = "172.20.0.0/16"
}

variable "service-cidr" {
  default = "172.21.0.0/20"
}

