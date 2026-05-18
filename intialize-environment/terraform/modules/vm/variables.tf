variable "resource_group_name" {
  description = "Resource group name"
  type        = string
}




variable "location" {
  description = "Azure region"
  type        = string
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

variable "subnet_id" {
  description = "Subnet ID"
  type        = string
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

variable "custom_image_id" {
  description = "Custom image resource ID. If empty, uses Ubuntu 24.04 marketplace image."
  type        = string
  default     = ""
}

variable "custom_data_template" {
  description = "Cloud-init template file (relative to module path). Set empty to skip."
  type        = string
  default     = "cloud-init.yaml"
}

variable "tags" {
  description = "Tags"
  type        = map(string)
  default     = {}
}