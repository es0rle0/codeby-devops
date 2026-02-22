variable "network_id" {
  type        = string
  description = "VPC network id"
  default     = null
}

variable "network_name" {
  type        = string
  description = "VPC network name (alternative to network_id)"
  default     = null
}

variable "folder_id" {
  type        = string
  description = "Folder id (optional)"
  default     = null
}

variable "zone" {
  type        = string
  description = "Target zone, e.g. ru-central1-a"
}

variable "name" {
  type        = string
  description = "VM name"
}

variable "cores" {
  type    = number
  default = 2
}

variable "memory" {
  type    = number
  default = 2
}

variable "disk_size_gb" {
  type    = number
  default = 15
}

variable "disk_type" {
  type    = string
  default = "network-hdd"
}

variable "nat" {
  type    = bool
  default = true
}

variable "ssh_user" {
  type    = string
  default = "ubuntu"
}

variable "ssh_public_key_path" {
  type    = string
  default = "~/.ssh/lesson14.pub"
}

variable "security_group_ids" {
  type        = list(string)
  default     = []
  description = "Optional SG ids to attach"
}
