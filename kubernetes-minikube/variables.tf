variable "access_key" {
  default = "xxxxxxxxxxxxxx"
}

variable "secret_key" {
  default = "xxxxxxxxxxxxxxxxxx
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

variable "vswitch_cidr" {
  default = "192.168.0.0/16"
}


variable "image_id" {
  default = "ubuntu_18_04_64_20G_alibase_20190624.vhd"
}

variable "k8s_short_name" {
  default = "hi-devopsk8s"
}

variable "ecs_password" {
  default = "xxxxxxxxxxx"
}

variable "internet_charge_type" {
  default = "PayByTraffic"
}

variable "internet_max_bandwidth_out" {
  default = 100
}

variable "disk_category" {
  default = "cloud_efficiency"
}

variable "username" {
  default = "xxxxxxxxxxxxxx"
}

