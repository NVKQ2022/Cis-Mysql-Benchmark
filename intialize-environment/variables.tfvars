# ============================================================
# Centralized Variables for MySQL CIS Benchmark
# Copy this to terraform.tfvars and update values
# DO NOT COMMIT THIS FILE TO GIT (already in .gitignore)
# ============================================================

# ===================
# Environment Config
# ===================
location            = "koreacentral"
resource_group_name = "cis-mysql-rg"

# ===================
# Key Vault Config
# ===================
key_vault_name = "cis-mysql-kv"

# ===================
# VM Configuration
# ===================
vm_size        = "Standard_B2ats_v2"
admin_username = "azureuser"

# ===================
# SENSITIVE - Replace with your actual values
# ===================
vm_admin_password       = "1234567890"
mysql_root_password     = "RootPass123!"
mysql_app_user_password = "UserPass123!"
tailscale_auth_key     = "tskey-auth-kfrvt8VVft11CNTRL-1ZNhcYFrMmL9uuGtdvQFmLfoH37dRNGBH"
# ===================
# Tags
# ===================
tags = {
  Environment = "CIS-MySQL-Benchmark"
  Project     = "MySQL-Security"
  ManagedBy   = "Terraform"
}
