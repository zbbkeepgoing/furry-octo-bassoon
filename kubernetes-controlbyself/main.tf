# Configure the Alicloud Provider
provider "alicloud" {
  access_key = var.access_key
  secret_key = var.secret_key
  region     = var.region
}

data "alicloud_vpcs" "vpc" {
  cidr_block = var.vpc_cidr 
}

data "alicloud_vswitches" "vswitch" {
  vpc_id            = data.alicloud_vpcs.vpc.vpcs.0.id
}

# Configure the instance type
data "alicloud_instance_types" "instance_types_master" {
  cpu_core_count 		= var.instance_cpu
  memory_size    		= var.instance_memory
  instance_type_family  = var.instance_type_family
  kubernetes_node_role  = "Worker"
}

# Configure the instance type
data "alicloud_instance_types" "instance_types_worker" {
  cpu_core_count 		= var.instance_cpu
  memory_size    		= var.instance_memory
  instance_type_family  = var.instance_type_family
  kubernetes_node_role  = "Worker"
}

data "alicloud_zones" "zones_ds" {
  available_instance_type = data.alicloud_instance_types.instance_types_master.instance_types[0].id
}

resource "alicloud_cs_kubernetes" "k8s" {
  name                      = var.k8s-name
  availability_zone         = data.alicloud_zones.zones_ds.zones.0.id
  vswitch_ids               = [data.alicloud_vswitches.vswitch.vswitches.0.id]
  new_nat_gateway           = true
  master_instance_types     = [data.alicloud_instance_types.instance_types_master.instance_types.0.id]
  worker_instance_types     = [data.alicloud_instance_types.instance_types_worker.instance_types.0.id]
  worker_numbers            = [var.worker_number]
  master_disk_category      = "cloud_efficiency"
  worker_disk_size          = 30
  worker_data_disk_category = "cloud_efficiency"
  worker_data_disk_size     = 30
  password                  = var.k8s-password
  pod_cidr                  = var.pod-cidr
  service_cidr              = var.service-cidr
  enable_ssh                = true
  slb_internet_enabled      = true
  node_cidr_mask            = 25
  install_cloud_monitor     = true
}

output "k8s-api-server-internet" {
  value = alicloud_cs_kubernetes.k8s.connections.api_server_internet
}

output "k8s-master-public-ip" {
  value = alicloud_cs_kubernetes.k8s.connections.master_public_ip
}


output "k8s-password" {
  value = var.k8s-password
}


