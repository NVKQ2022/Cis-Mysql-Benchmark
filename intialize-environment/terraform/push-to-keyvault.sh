#!/bin/bash
# ============================================================
# Push centralized variables.tfvars to Azure Key Vault
# Usage: ./push-to-keyvault.sh [key-vault-name]
# ============================================================

set -e

# Configuration
KEY_VAULT_NAME="${1:-$KEY_VAULT_NAME}"
VAR_FILE="variables.tfvars"
SECRET_PREFIX="tfvar-"

echo "=========================================="
echo "Pushing variables to Azure Key Vault"
echo "=========================================="
echo "Key Vault: $KEY_VAULT_NAME"
echo "File: $VAR_FILE"
echo ""

# Check if file exists
if [ ! -f "$VAR_FILE" ]; then
    echo "ERROR: $VAR_FILE not found!"
    echo "Create it first from variables.tfvars template."
    exit 1
fi

# Check Azure CLI
if ! command -v az &> /dev/null; then
    echo "ERROR: Azure CLI not installed"
    exit 1
fi

# Check if Key Vault exists
if ! az keyvault show --name "$KEY_VAULT_NAME" &> /dev/null; then
    echo "ERROR: Key Vault '$KEY_VAULT_NAME' not found!"
    echo "Create it first with: terraform apply -f 01-key-vault.tf"
    exit 1
fi

# Counters
PUSHED=0
SKIPPED=0
ERRORS=0

# Read and push each variable
echo "Pushing variables..."
while IFS='=' read -r key value; do
    # Skip comments and empty lines
    [[ "$key" =~ ^# ]] && continue
    [[ -z "$key" ]] && continue
    [[ "$key" =~ ^tags ]] && continue
    
    # Clean value (remove quotes)
    value=$(echo "$value" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
    value=$(echo "$value" | sed 's/^["'\'']//;s/["'\'']$//')
    
    # Skip if value is empty
    [ -z "$value" ] && ((SKIPPED++)) && continue
    
    # Skip sensitive keywords in name
    [[ "$key" =~ password|secret|key|token ]] && continue
    
    secret_name="${SECRET_PREFIX}${key}"
    
    # Push to Key Vault
    if az keyvault secret set \
        --vault-name "$KEY_VAULT_NAME" \
        --name "$secret_name" \
        --value "$value" \
        --output none 2>/dev/null; then
        echo "  ✓ $secret_name"
        ((PUSHED++))
    else
        echo "  ✗ $secret_name (failed)"
        ((ERRORS++))
    fi
    
done < <(grep -v '^#' "$VAR_FILE" | grep -v '^[[:space:]]*#' | grep -v '^$' | grep '=')

echo ""
echo "=========================================="
echo "Summary:"
echo "  Pushed: $PUSHED"
echo "  Skipped: $SKIPPED"
echo "  Errors: $ERRORS"
echo "=========================================="
echo ""

# Now handle sensitive variables separately
echo "Setting sensitive variables..."

# Define sensitive variables
SENSITIVE_VARS=(
    "vm_admin_password"
    "mysql_root_password"
    "mysql_app_user_password"
)

for var in "${SENSITIVE_VARS[@]}"; do
    # Get value from file
    value=$(grep "^${var}[[:space:]]*=" "$VAR_FILE" | cut -d'=' -f2- | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
    value=$(echo "$value" | sed 's/^["'\'']//;s/["'\'']$//')
    
    if [ -n "$value" ] && [ "$value" != "REPLACE_WITH_YOUR_VALUE" ]; then
        secret_name="${SECRET_PREFIX}${var}"
        if az keyvault secret set \
            --vault-name "$KEY_VAULT_NAME" \
            --name "$secret_name" \
            --value "$value" \
            --output none 2>/dev/null; then
            echo "  ✓ $secret_name (sensitive)"
            ((PUSHED++))
        else
            echo "  ✗ $secret_name (failed)"
            ((ERRORS++))
        fi
    fi
done

echo ""
echo "=========================================="
echo "COMPLETE!"
echo "=========================================="
echo ""
echo "Verify secrets:"
echo "  az keyvault secret list --vault-name $KEY_VAULT_NAME --output table"
echo ""
echo "To use in Terraform:"
echo "  1. Use sync-from-keyvault.sh to generate terraform.tfvars"
echo "  2. Or reference Key Vault directly in main.tf"