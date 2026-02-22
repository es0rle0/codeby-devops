output "selected_subnet_id" {
  value = local.selected_subnet_id
}

output "vm_id" {
  value = yandex_compute_instance.this.id
}

output "vm_private_ip" {
  value = yandex_compute_instance.this.network_interface[0].ip_address
}

output "vm_public_ip" {
  value = try(yandex_compute_instance.this.network_interface[0].nat_ip_address, null)
}
