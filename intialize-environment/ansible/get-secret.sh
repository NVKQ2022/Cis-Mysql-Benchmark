#!/bin/bash
# ============================================================
# Ansible: Get secrets from Azure Key Vault
# Simple shell script approach
# ============================================================

# Set these environment variables before running
# export AZURE_SUBSCRIPTION_ID="your-subscription-id"
# export AZURE_CLIENT_ID="your-client-id"
# export AZURE_CLIENT_SECRET="your-client-secret"
# export AZURE_TENANT="your-tenant-id"

KEY_VAULT_NAME="${KEY_VAULT_NAME:-cis-mysql-kv}"
SECRET_NAME="${SECRET_NAME:-mysql-root-password}"

echo "Getting secret '$SECRET_NAME' from Key Vault '$KEY_VAULT_NAME'..."

# Get secret using Azure CLI
SECRET_VALUE=$(az keyvault secret show \
  --vault-name "$KEY_VAULT_NAME" \
  --name "$SECRET_NAME" \
  --query "value" \
  --output tsv 2>/dev/null)

if [ -n "$SECRET_VALUE" ]; then
  echo "Secret retrieved successfully!"
  echo "Value: ${SECRET_VALUE:0:4}****${SECRET_VALUE: -4}"
else
  echo "Failed to retrieve secret"
  exit 1
fi