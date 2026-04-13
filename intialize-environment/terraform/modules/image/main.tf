# ============================================================
# Image Module
# ============================================================
resource "azurerm_image" "main" {
  name                = var.image_name
  location            = var.location
  resource_group_name = var.resource_group_name

  hyper_v_generation = var.hyper_v_generation

  source_virtual_machine_id = var.source_vm_id

  os_disk {
    caching = "ReadWrite"
  }

  tags = var.tags
}

output "image_id" {
  value = azurerm_image.main.id
}

output "image_name" {
  value = azurerm_image.main.name
}