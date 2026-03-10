resource "yandex_compute_instance" "manual" {
  name        = "lesson14-cfg2-vm-manual"
  platform_id = "standard-v3"

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      # ВАЖНО: ставим image_id как у вручную созданной ВМ (из твоего terraform plan)
      image_id = "fd8ihnnbgn1ot21ma5s4"
      size     = 15
      type     = "network-hdd"
    }
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.public.id
    nat                = true
    security_group_ids = [yandex_vpc_security_group.public.id]
  }

  metadata = {
    ssh-keys  = "${var.ssh_user}:${file(pathexpand(var.ssh_public_key_path))}"
    user-data = <<-EOT
      #cloud-config
      datasource:
       Ec2:
        strict_id: false
      ssh_pwauth: no
      users:
      - name: ubuntu
        sudo: ALL=(ALL) NOPASSWD:ALL
        shell: /bin/bash
        ssh_authorized_keys:
        - ${trimspace(file(pathexpand(var.ssh_public_key_path)))}
    EOT
  }

  lifecycle {
    ignore_changes = [metadata]
  }
}
