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

locals {
  name_prefix = "${var.project}-${var.env}"
}

data "yandex_compute_image" "ubuntu" {
  family = "ubuntu-2204-lts"
}

resource "yandex_vpc_network" "vpc" {
  name = "${local.name_prefix}-vpc"
}

# NAT gateway для выхода private-подсети в интернет (apt install)
resource "yandex_vpc_gateway" "nat" {
  name = "${local.name_prefix}-nat-gw"
  shared_egress_gateway {}
}

resource "yandex_vpc_route_table" "rt_private" {
  name       = "${local.name_prefix}-rt-private"
  network_id = yandex_vpc_network.vpc.id

  static_route {
    destination_prefix = "0.0.0.0/0"
    gateway_id         = yandex_vpc_gateway.nat.id
  }
}

resource "yandex_vpc_subnet" "public" {
  name           = "${local.name_prefix}-subnet-public"
  zone           = var.yc_zone
  network_id     = yandex_vpc_network.vpc.id
  v4_cidr_blocks = [var.public_cidr]
}

resource "yandex_vpc_subnet" "private" {
  name           = "${local.name_prefix}-subnet-private"
  zone           = var.yc_zone
  network_id     = yandex_vpc_network.vpc.id
  v4_cidr_blocks = [var.private_cidr]
  route_table_id = yandex_vpc_route_table.rt_private.id
}

resource "yandex_vpc_security_group" "public" {
  name       = "${local.name_prefix}-sg-public"
  network_id = yandex_vpc_network.vpc.id

  ingress {
    protocol       = "TCP"
    description    = "SSH"
    v4_cidr_blocks = [var.allowed_ssh_cidr]
    port           = 22
  }

  ingress {
    protocol       = "TCP"
    description    = "HTTP"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 80
  }

  ingress {
    protocol       = "TCP"
    description    = "HTTPS"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 443
  }

  egress {
    protocol       = "ANY"
    description    = "Allow all egress"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "yandex_vpc_security_group" "private" {
  name       = "${local.name_prefix}-sg-private"
  network_id = yandex_vpc_network.vpc.id

  ingress {
    protocol          = "TCP"
    description       = "SSH from public SG"
    security_group_id = yandex_vpc_security_group.public.id
    port              = 22
  }

  ingress {
    protocol          = "TCP"
    description       = "8080 from public SG"
    security_group_id = yandex_vpc_security_group.public.id
    port              = 8080
  }

  egress {
    protocol       = "ANY"
    description    = "Allow all egress"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "yandex_compute_instance" "vm_public" {
  name = "${local.name_prefix}-vm-public"

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.id
      size     = 15
    }
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.public.id
    nat                = true
    security_group_ids = [yandex_vpc_security_group.public.id]
  }

  metadata = {
    ssh-keys = "${var.ssh_user}:${file(pathexpand(var.ssh_public_key_path))}"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update -y",
      "sudo apt-get install -y nginx",
      "sudo systemctl enable --now nginx",
      "echo 'public ok' | sudo tee /var/www/html/lesson14.txt",
    ]
  }

  connection {
    type        = "ssh"
    host        = self.network_interface[0].nat_ip_address
    user        = var.ssh_user
    private_key = file(pathexpand(var.ssh_private_key_path))
    timeout     = "10m"
  }
}

resource "yandex_compute_instance" "vm_private" {
  name = "${local.name_prefix}-vm-private"

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.id
      size     = 15
    }
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.private.id
    nat                = false
    security_group_ids = [yandex_vpc_security_group.private.id]
  }

  metadata = {
    ssh-keys = "${var.ssh_user}:${file(pathexpand(var.ssh_public_key_path))}"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update -y",
      "sudo apt-get install -y nginx",
      "sudo sed -i 's/listen 80 default_server;/listen 8080 default_server;/' /etc/nginx/sites-available/default",
      "sudo sed -i 's/listen \\[::\\]:80 default_server;/listen [::]:8080 default_server;/' /etc/nginx/sites-available/default",
      "echo 'private ok' | sudo tee /var/www/html/lesson14.txt",
      "sudo systemctl restart nginx",
    ]
  }

  connection {
    type        = "ssh"
    host        = self.network_interface[0].ip_address
    user        = var.ssh_user
    private_key = file(pathexpand(var.ssh_private_key_path))
    timeout     = "15m"

    bastion_host        = yandex_compute_instance.vm_public.network_interface[0].nat_ip_address
    bastion_user        = var.ssh_user
    bastion_private_key = file(pathexpand(var.ssh_private_key_path))
  }

  depends_on = [yandex_compute_instance.vm_public]
}
