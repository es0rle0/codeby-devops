terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = ">= 0.110, < 1.0.0"
    }
  }
}

data "yandex_vpc_network" "this" {
  network_id = var.network_id
  name       = var.network_name
  folder_id  = var.folder_id
}

data "yandex_vpc_subnet" "subnets" {
  for_each  = toset(data.yandex_vpc_network.this.subnet_ids)
  subnet_id = each.value
}

locals {
  subnets_in_zone = [
    for s in values(data.yandex_vpc_subnet.subnets) : s.id
    if s.zone == var.zone
  ]

  selected_subnet_id = try(local.subnets_in_zone[0], null)
}

data "yandex_compute_image" "ubuntu" {
  family = "ubuntu-2204-lts"
}

resource "yandex_compute_instance" "this" {
  name        = var.name
  zone        = var.zone
  platform_id = "standard-v3"

  resources {
    cores  = var.cores
    memory = var.memory
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.id
      size     = var.disk_size_gb
      type     = var.disk_type
    }
  }

  network_interface {
    subnet_id          = local.selected_subnet_id
    nat                = var.nat
    security_group_ids = var.security_group_ids
  }

  metadata = {
    ssh-keys = "${var.ssh_user}:${file(pathexpand(var.ssh_public_key_path))}"
  }

  lifecycle {
    precondition {
      condition     = local.selected_subnet_id != null
      error_message = "No subnet found in VPC for zone '${var.zone}'. Choose another zone or create a subnet in that zone."
    }
  }
}
