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

variable "vpc_name" {
  type        = string
  description = "Existing VPC name to use"
  default     = "default"
}

variable "ssh_user" {
  type    = string
  default = "ubuntu"
}

variable "ssh_public_key_path" {
  type    = string
  default = "~/.ssh/lesson14.pub"
}

variable "vm_zone" {
  type        = string
  description = "Zone where VM should be created (subnet auto-selected by zone)"
  default     = "ru-central1-a"
}

variable "vm_name" {
  type    = string
  default = "lesson15-vm"
}

variable "vm_nat" {
  type    = bool
  default = true
}
