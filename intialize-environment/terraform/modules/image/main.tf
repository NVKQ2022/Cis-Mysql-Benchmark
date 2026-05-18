# ============================================================
# Image Module
# ============================================================
data "azurerm_managed_disk" "source" {
  name                = "${var.vm_name}-osdisk"
  resource_group_name = var.resource_group_name
}

resource "azurerm_image" "main" {
  name                = var.image_name
  location            = var.location
  resource_group_name = var.resource_group_name

  hyper_v_generation = var.hyper_v_generation

  os_disk {
    os_type         = "Linux"
    os_state        = "Generalized"
    managed_disk_id = data.azurerm_managed_disk.source.id
    caching         = "ReadWrite"
  }

  tags = var.tags
}

output "image_id" {
  value = azurerm_image.main.id
}

output "image_name" {
  value = azurerm_image.main.name
}