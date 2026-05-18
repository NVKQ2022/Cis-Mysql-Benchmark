# ============================================================
# Root Module: VM Infrastructure with Image + Gallery + Reports
# ============================================================

terraform {
  required_version = ">= 1.14.3"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}
}

# ============================================================
# Module: Resource Group
# ============================================================
module "resource_group" {
  source = "./modules/resource-group"

  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = var.tags
}

# ============================================================
# Module: Networking
# ============================================================
module "networking" {
  source = "./modules/networking"

  resource_group_name   = module.resource_group.name
  location              = module.resource_group.location
  vnet_name             = var.vnet_name
  vnet_address_space    = var.vnet_address_space
  subnet_name           = var.subnet_name
  subnet_address_prefix = var.subnet_address_prefix
  tags                  = var.tags
}

# ============================================================
# Module: VM
# ============================================================
module "vm" {
  source = "./modules/vm"

  resource_group_name     = module.resource_group.name
  location                = module.resource_group.location
  vm_name                 = var.vm_name
  vm_size                 = var.vm_size
  admin_username          = var.admin_username
  admin_password          = var.admin_password
  admin_ssh_public_key    = var.admin_ssh_public_key
  subnet_id               = module.networking.subnet_id
  mysql_root_password     = var.mysql_root_password
  mysql_app_database      = var.mysql_app_database
  mysql_app_user          = var.mysql_app_user
  mysql_app_user_password = var.mysql_app_user_password
  tailscale_auth_key      = var.tailscale_auth_key
  tags                    = var.tags
}

# ============================================================
# Module: Image (optional) — managed image from source VM
# ============================================================
module "image" {
  source = "./modules/image"

  count = var.create_image ? 1 : 0

  resource_group_name = module.resource_group.name
  location            = module.resource_group.location
  image_name          = var.image_name
  vm_name             = var.vm_name
  hyper_v_generation  = "V2"
  tags                = var.tags
}

# ============================================================
# Module: Image Gallery (optional) — gallery from managed image
# ============================================================
module "image_gallery" {
  source = "./modules/image-gallery"

  count = var.create_image ? 1 : 0

  resource_group_name = module.resource_group.name
  location            = module.resource_group.location
  gallery_name        = var.gallery_name
  image_name          = var.image_name
  image_version       = var.image_version
  managed_image_id    = module.image[0].image_id
  cis_description     = var.cis_report_description
  tags                = merge(var.tags, var.cis_report_tags)
}

# ============================================================
# Module: New VM from Image (optional) — hardened VM from gallery
# ============================================================
module "newvm" {
  source = "./modules/vm"

  count = var.create_image ? 1 : 0

  resource_group_name     = module.resource_group.name
  location                = module.resource_group.location
  vm_name                 = "cis-mysql-vm-hardened"
  vm_size                 = var.vm_size
  admin_username          = var.admin_username
  admin_password          = var.admin_password
  admin_ssh_public_key    = var.admin_ssh_public_key
  subnet_id               = module.networking.subnet_id
  mysql_root_password     = var.mysql_root_password
  mysql_app_database      = var.mysql_app_database
  mysql_app_user          = var.mysql_app_user
  mysql_app_user_password = var.mysql_app_user_password
  tailscale_auth_key      = var.tailscale_auth_key_hardened
  custom_image_id         = module.image_gallery[0].image_version_id
  custom_data_template    = "cloud-init.tailscale-only.yaml"
  tags                    = var.tags
}

# ============================================================
# Outputs
# ============================================================
output "resource_group" {
  value = {
    id       = module.resource_group.id
    name     = module.resource_group.name
    location = module.resource_group.location
  }
}

output "networking" {
  value = {
    vnet_id   = module.networking.vnet_id
    subnet_id = module.networking.subnet_id
    nsg_id    = module.networking.nsg_id
  }
}

output "vm" {
  value = {
    id     = module.vm.vm_id
    name   = module.vm.vm_name
    nic_id = module.vm.nic_id
  }
}

output "image" {
  value = var.create_image ? module.image[0].image_id : null
}

output "image_gallery" {
  value = var.create_image ? {
    id          = module.image_gallery[0].gallery_id
    name        = module.image_gallery[0].gallery_name
    version     = module.image_gallery[0].image_version
    version_id  = module.image_gallery[0].image_version_id
  } : null
}

output "newvm" {
  value = var.create_image ? {
    id     = module.newvm[0].vm_id
    name   = module.newvm[0].vm_name
    nic_id = module.newvm[0].nic_id
  } : null
}
