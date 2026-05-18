resource "azurerm_shared_image_gallery" "main" {
  name                = var.gallery_name
  location            = var.location
  resource_group_name = var.resource_group_name
  description         = "CIS MySQL hardened image gallery"

  tags = var.tags
}

resource "azurerm_shared_image" "main" {
  name                = var.image_name
  gallery_name        = azurerm_shared_image_gallery.main.name
  location            = var.location
  resource_group_name = var.resource_group_name
  os_type             = "Linux"
  hyper_v_generation  = "V2"
  description         = var.cis_description

  identifier {
    publisher = "CIS"
    offer     = "cis-mysql"
    sku       = "hardened"
  }

  tags = var.tags
}

resource "azurerm_shared_image_version" "main" {
  name                = var.image_version
  gallery_name        = azurerm_shared_image_gallery.main.name
  image_name          = azurerm_shared_image.main.name
  location            = var.location
  resource_group_name = var.resource_group_name

  managed_image_id = var.managed_image_id

  target_region {
    name                   = var.location
    regional_replica_count = 1
  }

  tags = var.tags
}
