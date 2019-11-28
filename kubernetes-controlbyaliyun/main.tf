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
data "alicloud_instance_types" "instance_types_worker" {
  cpu_core_count 		= var.instance_cpu
  memory_size    		= var.instance_memory
  instance_type_family  = var.instance_type_family
  kubernetes_node_role  = "Worker"
}

data "alicloud_zones" "zones_ds" {
  available_instance_type = data.alicloud_instance_types.instance_types_worker.instance_types[0].id
}


resource "alicloud_cs_managed_kubernetes" "k8s" {
  name                  = var.k8s-name
 # availability_zone     = data.alicloud_zones.zones_ds.zones.0.id
 # availability_zone     = ""
  vswitch_ids           = [data.alicloud_vswitches.vswitch.vswitches.0.id]
  new_nat_gateway       = true
  worker_instance_types = [data.alicloud_instance_types.instance_types_worker.instance_types.0.id]
  worker_number         = var.worker_number
  password              = var.k8s-password
  pod_cidr              = var.pod-cidr
  service_cidr          = var.service-cidr
  install_cloud_monitor = true
  slb_internet_enabled  = false
  worker_disk_category  = "cloud_efficiency"
}

output "k8s-password" {
  value = var.k8s-password
}


