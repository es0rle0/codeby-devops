variable "yc_cloud_id" { type = string }
variable "yc_folder_id" { type = string }

variable "yc_zone" {
  type    = string
  default = "ru-central1-a"
}

variable "yc_sa_key_file" {
  type    = string
  default = "~/.yc/authorized_key.json"
}

variable "project" {
  type    = string
  default = "lesson14"
}

variable "env" { type = string }

variable "public_cidr" { type = string }
variable "private_cidr" { type = string }

variable "allowed_ssh_cidr" {
  type    = string
  default = "0.0.0.0/0"
}

variable "ssh_user" {
  type    = string
  default = "ubuntu"
}

variable "ssh_public_key_path" {
  type    = string
  default = "~/.ssh/lesson14.pub"
}

variable "ssh_private_key_path" {
  type    = string
  default = "~/.ssh/lesson14"
}

variable "existing_vpc_name" {
  type        = string
  description = "Name of existing VPC network (created by config1)"
}

variable "existing_nat_gateway_id" {
  type        = string
  description = "ID of existing NAT gateway (created by config1)"
}
