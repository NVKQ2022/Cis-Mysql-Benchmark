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

variable "tailscale_auth_key_hardened" {
  description = "Tailscale auth key for hardened VM"
  type        = string
  default     = ""
}

variable "snapshot_name" {
  description = "Snapshot name"
  type        = string
  default     = "cis-mysql-snapshot"
}



variable "image_name" {
  description = "Custom image name"
  type        = string
  default     = "cis-mysql-image"
}




variable "create_resource_group" {
  description = "Create resource group"
  type        = bool
  default     = true
}

variable "create_networking" {
  description = "Create networking resources"
  type        = bool
  default     = true
}
variable "vnet_name" {
  description = "Virtual network name"
  type        = string
  default     = "cis-mysql-vnet"
}
variable "vnet_address_space" {
  description = "Virtual network address space"
  type        = list(string)
  default     = [" 10.0.0.0/16"]
}
variable "subnet_name" {
  description = "Subnet name"
  type        = string
  default     = "cis-mysql-subnet"
}
variable "subnet_address_prefix" {
  description = "Subnet address prefix"
  type        = string
  default     = "10.0.0.0/24"
}

variable "create_vm" {
  description = "Create VM"
  type        = bool
  default     = true
}


variable "create_snapshot" {
  description = "Create snapshot of VM"
  type        = bool
  default     = false
}

variable "create_image" {
  description = "Create image from VM"
  type        = bool
  default     = false
}

variable "custom_image_id" {
  description = "Custom image resource ID. If empty, uses Ubuntu 24.04 marketplace image."
  type        = string
  default     = ""
}

variable "gallery_name" {
  description = "Azure Compute Gallery name"
  type        = string
  default     = "cis-mysql-gallery"
}

variable "image_version" {
  description = "Image version for Compute Gallery (e.g. 1.0.0)"
  type        = string
  default     = "1.0.0"
}

variable "tags" {
  description = "Tags"
  type        = map(string)
  default     = {}
}

variable "cis_report_description" {
  description = "CIS benchmark summary for gallery image description (max 4096 chars)"
  type        = string
  default     = "CIS MySQL hardened image"
}

variable "cis_report_tags" {
  description = "CIS benchmark summary tags for gallery image (each value max 256 chars)"
  type        = map(string)
  default     = {}
}