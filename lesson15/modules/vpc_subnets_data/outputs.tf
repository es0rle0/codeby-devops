output "network_id" {
  value = data.yandex_vpc_network.this.id
}

output "subnet_ids" {
  value = data.yandex_vpc_network.this.subnet_ids
}

output "subnets" {
  value = local.subnets_list
}

output "subnet_ids_by_zone" {
  value = local.subnet_ids_by_zone
}
