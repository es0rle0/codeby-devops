output "public_ip" {
  value = yandex_compute_instance.vm_public.network_interface[0].nat_ip_address
}

output "private_ip" {
  value = yandex_compute_instance.vm_private.network_interface[0].ip_address
}

output "curl_public" {
  value = "curl http://${yandex_compute_instance.vm_public.network_interface[0].nat_ip_address}/lesson14.txt"
}

output "curl_private_from_public" {
  value = "curl http://${yandex_compute_instance.vm_private.network_interface[0].ip_address}:8080/lesson14.txt"
}
