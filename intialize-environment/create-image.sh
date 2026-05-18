#!/bin/bash
set -euo pipefail

RG="cis-mysql-rg"
VM="cis-mysql-vm"
IMAGE="${1:-cis-mysql-image}"

echo "=== Creating image: $IMAGE from $VM ==="

az image delete -g "$RG" -n "$IMAGE" 2>/dev/null || true

OS_DISK_ID=$(az vm show -g "$RG" -n "$VM" --query "storageProfile.osDisk.managedDisk.id" -o tsv)
az image create -g "$RG" -n "$IMAGE" --source "$OS_DISK_ID" --os-type Linux --hyper-v-generation V2

IMAGE_ID=$(az image show -g "$RG" -n "$IMAGE" --query id -o tsv)
echo ""
echo "=== Image created! ==="
echo "Name: $IMAGE"
echo "ID:   $IMAGE_ID"
