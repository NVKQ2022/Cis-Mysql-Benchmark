output "gallery_id" {
  value = azurerm_shared_image_gallery.main.id
}

output "gallery_name" {
  value = azurerm_shared_image_gallery.main.name
}

output "definition_id" {
  value = azurerm_shared_image.main.id
}

output "image_version_id" {
  value = azurerm_shared_image_version.main.id
}

output "image_version" {
  value = azurerm_shared_image_version.main.name
}
