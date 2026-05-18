variable "resource_group_name" {
  description = "Resource group name"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "image_name" {
  description = "Custom image name"
  type        = string
  default     = "cis-mysql-image"
}

variable "vm_name" {
  description = "VM name (to derive OS disk name)"
  type        = string
}

variable "hyper_v_generation" {
  description = "Hyper-V generation (V1 or V2)"
  type        = string
  default     = "V2"
}

variable "tags" {
  description = "Tags"
  type        = map(string)
  default     = {}
}