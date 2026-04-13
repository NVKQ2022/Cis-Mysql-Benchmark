variable "resource_group_name" {
  description = "Resource group name"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "snapshot_name" {
  description = "Snapshot name"
  type        = string
  default     = "cis-mysql-snapshot"
}

variable "source_disk_name" {
  description = "Source managed disk name to snapshot"
  type        = string
}

variable "tags" {
  description = "Tags"
  type        = map(string)
  default     = {}
}