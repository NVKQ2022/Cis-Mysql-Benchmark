# ============================================================
# Root Module Variables
# ============================================================

variable "location" {
  description = "Azure region"
  type        = string
  default     = "koreacentral"
}

variable "resource_group_name" {
  description = "Resource group name"
  type        = string
  default     = "cis-mysql-rg"
}

variable "vm_name" {
  description = "VM name"
  type        = string
  default     = "cis-mysql-vm"
}

variable "vm_size" {
  description = "VM size"
  type        = string
  default     = "Standard_B2ats_v2"
}

variable "admin_username" {
  description = "Admin username"
  type        = string
  default     = "azureuser"
}

variable "admin_password" {
  description = "Admin password"
  type        = string
  sensitive   = true
}

variable "admin_ssh_public_key" {
  description = "SSH public key"
  type        = string
  default     = ""
}

variable "mysql_root_password" {
  description = "MySQL root password"
  type        = string
  sensitive   = true
}

variable "mysql_app_database" {
  description = "MySQL application database"
  type        = string
  default     = "app_db"
}

variable "mysql_app_user" {
  description = "MySQL application user"
  type        = string
  default     = "app_user"
}

variable "mysql_app_user_password" {
  description = "MySQL application user password"
  type        = string
  sensitive   = true
}

variable "tailscale_auth_key" {
  description = "Tailscale auth key"
  type        = string
  default     = ""
}

variable "snapshot_name" {
  description = "Snapshot name"
  type        = string
  default     = "cis-mysql-snapshot"
}

variable "create_snapshot" {
  description = "Create snapshot of VM"
  type        = bool
  default     = false
}

variable "image_name" {
  description = "Custom image name"
  type        = string
  default     = "cis-mysql-image"
}

variable "create_image" {
  description = "Create image from VM"
  type        = bool
  default     = false
}

variable "tags" {
  description = "Tags"
  type        = map(string)
  default     = {}
}