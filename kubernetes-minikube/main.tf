# Configure the Alicloud Provider
provider "alicloud" {
  access_key = var.access_key
  secret_key = var.secret_key
  region     = var.region
}

# Configure the instance type
data "alicloud_instance_types" "instance_type" {
  cpu_core_count 		= var.instance_cpu
  memory_size    		= var.instance_memory
  instance_type_family  = var.instance_type_family
}

data "alicloud_vpcs" "vpc" {
  cidr_block = var.vpc_cidr 
}

data "alicloud_zones" "zones_ds" {
  available_instance_type = data.alicloud_instance_types.instance_type.instance_types[0].id
}

data "alicloud_vswitches" "vswitch" {
  vpc_id            = data.alicloud_vpcs.vpc.vpcs.0.id
  cidr_block        = var.vswitch_cidr
}

# Network Security Group for k8s Vm
resource "alicloud_security_group" "k8s-group" {
  name        = var.k8s_short_name
  vpc_id      = data.alicloud_vpcs.vpc.vpcs.0.id
  description = "security group for devops k8s vm"
}

resource "alicloud_security_group_rule" "k8s-in-2376" {
  type              = "ingress"
  ip_protocol       = "tcp"
  nic_type          = "intranet"
  policy            = "accept"
  port_range        = "2376/2376"
  priority          = 1
  security_group_id = alicloud_security_group.k8s-group.id
  cidr_ip           = "0.0.0.0/0"
}

resource "alicloud_security_group_rule" "k8s-in-443" {
  type              = "ingress"
  ip_protocol       = "tcp"
  nic_type          = "intranet"
  policy            = "accept"
  port_range        = "443/443"
  priority          = 1
  security_group_id = alicloud_security_group.k8s-group.id
  cidr_ip           = "0.0.0.0/0"
}

resource "alicloud_security_group_rule" "k8s-in-8080" {
  type              = "ingress"
  ip_protocol       = "tcp"
  nic_type          = "intranet"
  policy            = "accept"
  port_range        = "8080/8080"
  priority          = 1
  security_group_id = alicloud_security_group.k8s-group.id
  cidr_ip           = "0.0.0.0/0"
}


resource "alicloud_security_group_rule" "k8s-in-22" {
  type              = "ingress"
  ip_protocol       = "tcp"
  nic_type          = "intranet"
  policy            = "accept"
  port_range        = "22/22"
  priority          = 1
  security_group_id = alicloud_security_group.k8s-group.id
  cidr_ip           = "0.0.0.0/0"
}




resource "alicloud_instance" "instance-k8s" {
  instance_name     = "${var.k8s_short_name}-${var.username}"
  host_name         = "${var.k8s_short_name}-${var.username}"
  image_id          = var.image_id
  instance_type     = data.alicloud_instance_types.instance_type.instance_types[0].id
  availability_zone = data.alicloud_zones.zones_ds.zones[0].id
  security_groups   = alicloud_security_group.k8s-group.*.id
  vswitch_id      	= data.alicloud_vswitches.vswitch.vswitches.0.id
  
  internet_charge_type       = var.internet_charge_type
  internet_max_bandwidth_out = var.internet_max_bandwidth_out

  password = var.ecs_password

  instance_charge_type = "PostPaid"
  system_disk_category = "cloud_efficiency"
  spot_strategy        = "SpotWithPriceLimit"

  tags = {
    username = var.username
  }
  
  user_data = file("minikube.sh")
  
}

output "k8s" {
  value = alicloud_instance.instance-k8s.public_ip
}

output "root_passwd" {
  value = var.ecs_password
}
