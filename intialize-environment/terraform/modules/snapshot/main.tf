# ============================================================
# Snapshot Module
# ============================================================
data "azurerm_managed_disk" "source" {
  name                = var.source_disk_name
  resource_group_name = var.resource_group_name
}

resource "azurerm_snapshot" "main" {
  name                = var.snapshot_name
  location            = var.location
  resource_group_name = var.resource_group_name
  create_option       = "Copy"
  source_uri          = data.azurerm_managed_disk.source.id

  tags = var.tags
}

output "snapshot_id" {
  value = azurerm_snapshot.main.id
}

output "snapshot_name" {
  value = azurerm_snapshot.main.name
}