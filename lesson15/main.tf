terraform {
  required_version = ">= 1.5.0"
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = ">= 0.110, < 1.0.0"
    }
  }
}

provider "yandex" {
  cloud_id                 = var.yc_cloud_id
  folder_id                = var.yc_folder_id
  zone                     = var.yc_zone
  service_account_key_file = pathexpand(var.yc_sa_key_file)
}

# We use an existing VPC (default name is "default")
module "subnets_data" {
  source       = "./modules/vpc_subnets_data"
  network_name = var.vpc_name
  folder_id    = var.yc_folder_id
}

# VM is created in the provided zone; subnet is auto-selected by zone
module "vm" {
  source              = "./modules/vm_auto_subnet"
  network_name        = var.vpc_name
  folder_id           = var.yc_folder_id
  zone                = var.vm_zone
  name                = var.vm_name
  nat                 = var.vm_nat
  ssh_user            = var.ssh_user
  ssh_public_key_path = var.ssh_public_key_path
}
