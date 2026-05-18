#!/bin/bash
set -euo pipefail

RG="cis-mysql-rg"
VM="cis-mysql-vm"
NEW_VM="cis-mysql-vm-hardened"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
TF_DIR="$SCRIPT_DIR/terraform"
ANSIBLE_DIR="$SCRIPT_DIR/ansible"
TFVARS="$TF_DIR/variables.tfvars"
TFVARS_BAK="$TFVARS.bak.$(date +%Y%m%d%H%M%S)"
INVENTORY="$ANSIBLE_DIR/inventory.ini"

echo "============================================"
echo " CIS MySQL Benchmark - Build Image + Redeploy"
echo "============================================"
echo "Source VM : $VM"
echo "Image     : $(grep ^image_name "$TFVARS" | head -1 | cut -d= -f2 | tr -d ' \"')"
echo "Target VM : $NEW_VM"
echo ""

# ------------------------------------------------------------------
echo "=== 1. Stop MySQL on source VM for clean image ==="
az vm run-command invoke -g "$RG" -n "$VM" \
  --command-id RunShellScript \
  --scripts "systemctl stop mysql && sync" 2>&1 | grep -v "RunShellScript"

# ------------------------------------------------------------------
echo "=== 2. Backup tfvars ==="
cp "$TFVARS" "$TFVARS_BAK"
echo "Backup: $TFVARS_BAK"

# ------------------------------------------------------------------
echo "=== 3. Enable image creation ==="
sed -i 's/^create_image\s*=.*/create_image            = true/' "$TFVARS"
echo "Updated $TFVARS"

# ------------------------------------------------------------------
echo "=== 4. Run terraform apply ==="
cd "$TF_DIR"
terraform init 2>&1 | tail -3
terraform apply -auto-approve 2>&1 | tail -10

# ------------------------------------------------------------------
echo "=== 5. Tag gallery image with ReportUrl (if REPORT_URL is set) ==="
REPORT_URL="${REPORT_URL:-}"
if [ -n "$REPORT_URL" ]; then
  GALLERY_VERSION_ID=$(terraform output -json image_gallery 2>/dev/null | python3 -c "import sys,json; d=json.load(sys.stdin); print(d.get('version_id',''))" 2>/dev/null || echo "")
  if [ -n "$GALLERY_VERSION_ID" ]; then
    echo "  Tagging gallery image with ReportUrl=$REPORT_URL"
    az resource update \
      --ids "$GALLERY_VERSION_ID" \
      --set tags.ReportUrl="$REPORT_URL" \
      --only-show-errors 2>/dev/null || \
    echo "  (Warning: could not tag gallery image version)"
  fi
else
  echo "  REPORT_URL not set — skip tagging"
fi

# ------------------------------------------------------------------
echo "=== 6. Get new VM information ==="
NEW_VM_NAME=$(terraform output -json newvm 2>/dev/null | python3 -c "import sys,json; d=json.load(sys.stdin); print(d.get('name',''))" 2>/dev/null || echo "$NEW_VM")
echo "New VM name: $NEW_VM_NAME"

# ------------------------------------------------------------------
echo "=== 7. Wait for new VM in Tailscale ==="
TAILSCALE_IP=""
for i in $(seq 1 60); do
  TAILSCALE_IP=$(tailscale status 2>/dev/null | grep -i "$NEW_VM" | awk '{print $1}' || true)
  if [ -n "$TAILSCALE_IP" ]; then
    echo "Found! IP: $TAILSCALE_IP after $(( i * 10 ))s"
    break
  fi
  echo "Waiting for $NEW_VM in Tailscale... attempt $i (${i}0s)"
  sleep 10
done

if [ -z "$TAILSCALE_IP" ]; then
  echo "ERROR: $NEW_VM not found in Tailscale after 10 minutes"
  echo "You can check manually: tailscale status | grep $NEW_VM"
  echo "Then update the inventory manually."
  exit 1
fi

# ------------------------------------------------------------------
echo "=== 8. Update Ansible inventory ==="
cp "$INVENTORY" "$INVENTORY.bak"
sed -i "s/ansible_host=$VM/ansible_host=$NEW_VM/" "$INVENTORY"
sed -i "s/^azure-vm /$NEW_VM /" "$INVENTORY"
echo "Inventory updated: $INVENTORY"

# ------------------------------------------------------------------
echo "=== 9. Test connectivity to new VM ==="
echo "Waiting for SSH to be ready..."
for i in $(seq 1 30); do
  if timeout 5 ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o ConnectTimeout=5 \
    "azureuser@$TAILSCALE_IP" "hostname" 2>/dev/null; then
    echo "SSH ready!"
    break
  fi
  echo "Waiting for SSH... attempt $i"
  sleep 10
done

# ------------------------------------------------------------------
echo ""
echo "============================================"
echo " SUCCESS!"
echo "============================================"
echo "Image       : $(grep ^image_name "$TFVARS" | head -1 | cut -d= -f2 | tr -d ' \"')"
echo "Old VM      : $VM"
echo "New VM      : $NEW_VM ($TAILSCALE_IP)"
echo "Report URL  : ${REPORT_URL:-Not set (export REPORT_URL=<url> then re-tag)}"
echo ""
echo "What to do next:"
echo "  1. Restart MySQL on the new VM:"
echo "     ssh azureuser@$TAILSCALE_IP 'sudo systemctl start mysql'"
echo ""
echo "  2. Run Ansible against the new VM:"
echo "     ansible-playbook -i $INVENTORY ..."
echo ""
echo "  3. When the new VM is verified, destroy the old one:"
echo "     az vm delete -g $RG -n $VM --keep-disks"
echo ""
echo "  To revert the inventory:"
echo "     cp $INVENTORY.bak $INVENTORY"
echo ""
echo "NOTE: tfvars was updated. To revert to normal mode:"
echo "  cp $TFVARS_BAK $TFVARS"
echo "  # Run terraform apply first after reversion"
echo "============================================"
