# MySQL CIS Benchmark - Environment Setup

## Azure VM Deployment (Terraform)

```bash
cd intialize-environment

# Deploy VM
terraform init
terraform apply

# Get VM IP
terraform output vm_ip
```

## MySQL Installation

### Option 1: Ansible (Recommended)
```bash
# Update inventory.ini with your VM IP
vim inventory.ini

# Install MySQL
ansible-playbook -i inventory.ini install-mysql.yml

# Run Manual Audit (Section 2)
ansible-playbook -i inventory.ini manual-audit-section2.yml
```

### Option 2: Manual
```bash
ssh azureuser@<VM_IP>
sudo ./init.sh
```

## Manual Audit (Section 2)

Run on VM after MySQL installation:
```bash
# Set password for audit scripts
export MYSQL_ROOT_PASSWORD="YourSecurePassword123!"

# Run all section 2 audits
cd manual-audit/2_installation_and_planning
for d in */; do
    sudo ./"${d}"check.sh
done

# View reports
cat */audit_report.txt
```

## Files

| File | Description |
|------|-------------|
| `main.tf` | Terraform - Azure VM |
| `inventory.ini` | Ansible inventory |
| `install-mysql.yml` | Ansible - Install MySQL |
| `manual-audit-section2.yml` | Ansible - Section 2 Audit |
| `init.sh` | Manual MySQL install script |

## Cleanup

```bash
terraform destroy
```
