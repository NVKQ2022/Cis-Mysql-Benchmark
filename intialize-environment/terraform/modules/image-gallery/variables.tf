variable "resource_group_name" {
  description = "Resource group name"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "gallery_name" {
  description = "Azure Compute Gallery name"
  type        = string
  default     = "cis-mysql-gallery"
}

variable "image_name" {
  description = "Image definition name inside the gallery"
  type        = string
  default     = "cis-mysql-image-hardened"
}

variable "image_version" {
  description = "Image version (e.g. 1.0.0)"
  type        = string
  default     = "1.0.0"
}

variable "managed_image_id" {
  description = "ID of the source managed image (azurerm_image)"
  type        = string
}

variable "cis_description" {
  description = "CIS benchmark summary for image description"
  type        = string
  default     = "CIS MySQL hardened image"
}

variable "tags" {
  description = "Tags"
  type        = map(string)
  default     = {}
}
