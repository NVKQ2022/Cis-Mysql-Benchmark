variable "resource_group_name" {
  description = "Resource group name"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "key_vault_name" {
  description = "Key Vault name"
  type        = string
  default     = "cis-mysql-kv"
}

variable "tenant_id" {
  description = "Azure tenant ID"
  type        = string
}

variable "object_id" {
  description = "User object ID for access"
  type        = string
}

variable "secrets" {
  description = "Map of secret names and values"
  type        = map(string)
  default     = {}
}

variable "tags" {
  description = "Tags"
  type        = map(string)
  default     = {}
}