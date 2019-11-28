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

resource "alicloud_vpc" "vpc" {
  cidr_block = var.vpc_cidr 
}

data "alicloud_zones" "zones_ds" {
  available_instance_type = data.alicloud_instance_types.instance_type.instance_types[0].id
}

resource "alicloud_vswitch" "vswitch" {
  vpc_id            = alicloud_vpc.vpc.id
  cidr_block        = var.vswitch_cidr
  availability_zone = data.alicloud_zones.zones_ds.zones[0].id
}

# Network Security Group for Master Vm
resource "alicloud_security_group" "master-group" {
  name        = var.master_short_name
  vpc_id      = alicloud_vpc.vpc.id
  description = "security group for devops master vm"
}

resource "alicloud_security_group_rule" "jenkins-in-10000" {
  type              = "ingress"
  ip_protocol       = "tcp"
  nic_type          = "intranet"
  policy            = "accept"
  port_range        = "10000/10000"
  priority          = 1
  security_group_id = alicloud_security_group.master-group.id
  cidr_ip           = "0.0.0.0/0"
}

resource "alicloud_security_group_rule" "jenkins-in-50000" {
  type              = "ingress"
  ip_protocol       = "tcp"
  nic_type          = "intranet"
  policy            = "accept"
  port_range        = "50000/50000"
  priority          = 1
  security_group_id = alicloud_security_group.master-group.id
  cidr_ip           = "0.0.0.0/0"
}

resource "alicloud_security_group_rule" "master-web-in" {
  type              = "ingress"
  ip_protocol       = "tcp"
  nic_type          = "intranet"
  policy            = "accept"
  port_range        = "8080/8080"
  priority          = 1
  security_group_id = alicloud_security_group.master-group.id
  cidr_ip           = "0.0.0.0/0"
}


resource "alicloud_security_group_rule" "mater-ssh-in" {
  type              = "ingress"
  ip_protocol       = "tcp"
  nic_type          = "intranet"
  policy            = "accept"
  port_range        = "22/22"
  priority          = 1
  security_group_id = alicloud_security_group.master-group.id
  cidr_ip           = "0.0.0.0/0"
}


# Network Security Group for Slave Vm
resource "alicloud_security_group" "slave-group" {
  name        = var.slave_short_name
  vpc_id      = alicloud_vpc.vpc.id
  description = "security group for devops slave vm"
}

resource "alicloud_security_group_rule" "docker-in" {
  type              = "ingress"
  ip_protocol       = "tcp"
  nic_type          = "intranet"
  policy            = "accept"
  port_range        = "2376/2376"
  priority          = 1
  security_group_id = alicloud_security_group.slave-group.id
  cidr_ip           = "0.0.0.0/0"
}

resource "alicloud_security_group_rule" "sonar-in-1" {
  type              = "ingress"
  ip_protocol       = "tcp"
  nic_type          = "intranet"
  policy            = "accept"
  port_range        = "9000/9000"
  priority          = 1
  security_group_id = alicloud_security_group.slave-group.id
  cidr_ip           = "0.0.0.0/0"
}

resource "alicloud_security_group_rule" "sonar-in-2" {
  type              = "ingress"
  ip_protocol       = "tcp"
  nic_type          = "intranet"
  policy            = "accept"
  port_range        = "9092/9092"
  priority          = 1
  security_group_id = alicloud_security_group.slave-group.id
  cidr_ip           = "0.0.0.0/0"
}

resource "alicloud_security_group_rule" "slave-web-in" {
  type              = "ingress"
  ip_protocol       = "tcp"
  nic_type          = "intranet"
  policy            = "accept"
  port_range        = "8080/8080"
  priority          = 1
  security_group_id = alicloud_security_group.slave-group.id
  cidr_ip           = "0.0.0.0/0"
}


resource "alicloud_security_group_rule" "slave-ssh-in" {
  type              = "ingress"
  ip_protocol       = "tcp"
  nic_type          = "intranet"
  policy            = "accept"
  port_range        = "22/22"
  priority          = 1
  security_group_id = alicloud_security_group.slave-group.id
  cidr_ip           = "0.0.0.0/0"
}

resource "alicloud_instance" "instance-master" {
  instance_name     = "${var.master_short_name}-${var.username}"
  host_name         = "${var.master_short_name}-${var.username}"
  image_id          = var.image_id
  instance_type     = data.alicloud_instance_types.instance_type.instance_types[0].id
  availability_zone = data.alicloud_zones.zones_ds.zones[0].id
  security_groups   = alicloud_security_group.master-group.*.id
  vswitch_id      	= alicloud_vswitch.vswitch.id
  
  internet_charge_type       = var.internet_charge_type
  internet_max_bandwidth_out = var.internet_max_bandwidth_out

  password = var.ecs_password

  instance_charge_type = "PostPaid"
  system_disk_category = "cloud_efficiency"
  spot_strategy        = "SpotWithPriceLimit"
  spot_price_limit     = "0.2"

  tags = {
    username = var.username
  }
  
  user_data = file("masterfrompull.sh")
  
}

resource "alicloud_instance" "instance-slave" {
  instance_name     = "${var.slave_short_name}-${var.username}"
  host_name         = "${var.slave_short_name}-${var.username}"
  image_id          = var.image_id
  instance_type     = data.alicloud_instance_types.instance_type.instance_types[0].id
  availability_zone = data.alicloud_zones.zones_ds.zones[0].id
  security_groups   = alicloud_security_group.slave-group.*.id
  vswitch_id      	= alicloud_vswitch.vswitch.id
  
  internet_charge_type       = var.internet_charge_type
  internet_max_bandwidth_out = var.internet_max_bandwidth_out

  password = var.ecs_password

  instance_charge_type = "PostPaid"
  system_disk_category = "cloud_efficiency"
  spot_strategy        = "SpotWithPriceLimit"
  spot_price_limit     = "0.2"

  tags = {
    username = var.username
  }
  
  user_data = file("slaveinit.sh")
  
}


output "master_ip" {
  value = alicloud_instance.instance-master.public_ip
}
output "slave_ip" {
  value = alicloud_instance.instance-slave.public_ip
}

output "root_passwd" {
  value = var.ecs_password
}
