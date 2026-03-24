output "all_subnets" {
  description = "All subnets in selected VPC"
  value       = module.subnets_data.subnets
}

output "subnet_ids_by_zone" {
  description = "Subnet ids grouped by zone"
  value       = module.subnets_data.subnet_ids_by_zone
}

output "vm_selected_subnet_id" {
  description = "Subnet id automatically chosen for VM based on zone"
  value       = module.vm.selected_subnet_id
}

output "vm_id" {
  value = module.vm.vm_id
}

output "vm_public_ip" {
  value = module.vm.vm_public_ip
}
