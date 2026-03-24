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
