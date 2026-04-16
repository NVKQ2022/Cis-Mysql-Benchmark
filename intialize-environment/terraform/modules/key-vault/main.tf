# ============================================================
# Key Vault Module
# ============================================================
resource "azurerm_key_vault" "main" {
  name                = var.key_vault_name
  location            = var.location
  resource_group_name = var.resource_group_name
  tenant_id           = var.tenant_id
  sku_name            = "standard"

  enable_rbac_authorization  = false
  soft_delete_retention_days = 7

  network_acls {
    bypass         = "AzureServices"
    default_action = "Allow"
  }

  access_policy {
    tenant_id = var.tenant_id
    object_id = var.object_id

    secret_permissions = [
      "Get", "List", "Set", "Delete", "Recover", "Restore"
    ]
  }

  tags = var.tags
}

resource "azurerm_key_vault_secret" "secrets" {
  for_each     = toset(keys(var.secrets))
  name         = each.key
  key_vault_id = azurerm_key_vault.main.id
  value        = var.secrets[each.key]
}

output "key_vault_id" {
  value = azurerm_key_vault.main.id
}

output "key_vault_name" {
  value = azurerm_key_vault.main.name
}

output "vault_uri" {
  value = azurerm_key_vault.main.vault_uri
}