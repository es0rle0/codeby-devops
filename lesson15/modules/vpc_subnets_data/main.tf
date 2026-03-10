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
  subnets_list = [
    for s in values(data.yandex_vpc_subnet.subnets) : {
      id          = s.id
      name        = s.name
      zone        = s.zone
      v4_cidr     = s.v4_cidr_blocks
      network_id  = s.network_id
      route_table = try(s.route_table_id, null)
    }
  ]

  zones = distinct([for s in local.subnets_list : s.zone])

  subnet_ids_by_zone = {
    for z in local.zones : z => [for s in local.subnets_list : s.id if s.zone == z]
  }
}
