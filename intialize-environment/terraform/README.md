# Terraform Configuration for MySQL CIS Benchmark

## Files

| File | Purpose |
|------|---------|
| `main.tf` | Root module - uses sub-modules |
| `variables.tf` | Variable definitions |
| `variables.tfvars` | Centralized variables template |
| `cloud-init.yaml` | VM initialization script |
| `modules/` | Reusable infrastructure modules |
| `push-to-keyvault.sh` | Push variables to Key Vault |
| `pull-from-keyvault.sh` | Pull secrets from Key Vault |
| `.gitignore` | Block secrets in git |

## Module Structure

```
modules/
├── resource-group/     # Azure Resource Group
├── networking/         # VNet, Subnet, NSG
├── key-vault/         # Key Vault + Secrets
└── vm/               # Linux VM + cloud-init
```

## Quick Start

### 1. Create Key Vault
```bash
cd terraform
terraform init
terraform apply -f 01-key-vault.tf
```

### 2. Push variables to Key Vault
```bash
# Edit variables.tfvars with your values first
vim variables.tfvars

# Push to Key Vault
./push-to-keyvault.sh
```

### 3. Deploy infrastructure
```bash
terraform apply
```

## Variables Management

### Workflow

```
┌─────────────────┐     ┌─────────────────┐     ┌─────────────────┐
│  variables.tfvars│────▶│  Key Vault     │────▶│  Terraform     │
│  (edit locally)  │     │  (shared store)│     │  (read from KV)│
└─────────────────┘     └─────────────────┘     └─────────────────┘
        │                       ▲
        │ push-to-keyvault.sh  │ pull-from-keyvault.sh
        ▼                       │
┌─────────────────┐            │
│  .gitignore    │            │
│  *.tfvars      │            │
└─────────────────┘
```

### Commands

```bash
# 1. Edit variables (from template)
cp variables.tfvars terraform.tfvars
vim terraform.tfvars

# 2. Push to Key Vault (share with team)
./push-to-keyvault.sh

# 3. Pull from Key Vault (sync)
./pull-from-keyvault.sh

# 4. Run Terraform
terraform init
terraform plan
terraform apply

# 5. Destroy
terraform destroy
```

## Key Vault Secrets

| Secret Name | Description |
|-------------|-------------|
| `tfvar-*` | All variables from tfvars |
| `mysql-root-password` | MySQL root password |
| `vm-admin-password` | VM admin password |

## Security

- **NEVER commit** `terraform.tfvars` to git
- **ALWAYS use** `.gitignore` (already configured)
- **Share secrets** via Key Vault, not files
- **Use pull-from-keyvault.sh** to sync team variables

## Example Output

After running `terraform apply`:

```
Outputs:
resource_group = {
  "id" = "/subscriptions/.../resourceGroups/cis-mysql-rg"
  "location" = "koreacentral"
  "name" = "cis-mysql-rg"
}
vm = {
  "id" = "/subscriptions/.../virtualMachines/cis-mysql-vm"
  "name" = "cis-mysql-vm"
  "public_ip" = "20.123.45.67"
}
```