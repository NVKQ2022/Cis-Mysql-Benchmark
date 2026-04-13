# ============================================================
# Create Azure Key Vault and Secrets
# Run this to initialize secrets
# ============================================================

# Login to Azure
az login

# Create Resource Group
az group create \
  --name cis-mysql-rg \
  --location koreacentral

# Create Key Vault
az keyvault create \
  --name cis-mysql-kv \
  --resource-group cis-mysql-rg \
  --location koreacentral \
  --sku standard \
  --enable-rbac-authorization false

# Add secrets
az keyvault secret set \
  --vault-name cis-mysql-kv \
  --name mysql-root-password \
  --value "YourSecurePassword123!"

az keyvault secret set \
  --vault-name cis-mysql-kv \
  --name vm-admin-password \
  --value "P@ssw0rd1234!"

az keyvault secret set \
  --vault-name cis-mysql-kv \
  --name mysql-backup-password \
  --value "BackupPass123!"

echo "Key Vault created successfully!"
echo "Vault name: cis-mysql-kv"
echo ""
echo "List secrets:"
az keyvault secret list --vault-name cis-mysql-kv --output table