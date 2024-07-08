module "threetier" {

  source = "../module"

  prefix = var.prefix
  location = var.location[0]
  env = var.env[0]

  ############################ Azure VM ################################# 

  vm_count_rabbitmq = var.vm_count_rabbitmq  
  vm_count_memcached = var.vm_count_memcached
  vm_size = var.vm_size[0]
  availability_zone = var.availability_zone
  static_dynamic = var.static_dynamic
  disk_size_gb = var.disk_size_gb
  extra_disk_size_gb = var.extra_disk_size_gb
  computer_name  = var.computer_name
  admin_username = var.admin_username
  admin_password = var.admin_password

}
