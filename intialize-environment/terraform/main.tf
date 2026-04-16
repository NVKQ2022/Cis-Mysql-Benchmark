# ============================================================
# Root Module: VM Infrastructure with Snapshot
# ============================================================

terraform {
  required_version = ">= 1.0"
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
  vnet_name             = "mysql-vnet"
  vnet_address_space    = ["10.0.0.0/16"]
  subnet_name           = "mysql-subnet"
  subnet_address_prefix = "10.0.0.0/24"
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
# Module: Snapshot (optional)
# ============================================================
module "snapshot" {
  source = "./modules/snapshot"

  count = var.create_snapshot ? 1 : 0

  resource_group_name = module.resource_group.name
  location            = module.resource_group.location
  snapshot_name       = var.snapshot_name
  source_disk_name    = "${var.vm_name}-osdisk"
  tags                = var.tags
}

# ============================================================
# Module: Image (optional)
# ============================================================
module "image" {
  source = "./modules/image"

  count = var.create_image ? 1 : 0

  resource_group_name = module.resource_group.name
  location            = module.resource_group.location
  image_name          = var.image_name
  source_vm_id        = module.vm.vm_id
  hyper_v_generation  = "V2"
  tags                = var.tags
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

output "snapshot" {
  value = var.create_snapshot ? module.snapshot[0].snapshot_id : ""
}

output "image" {
  value = var.create_image ? module.image[0].image_id : ""
}