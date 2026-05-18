#!/bin/bash
set -euo pipefail

INVENTORY="intialize-environment/ansible/newinventory.ini"
SECTIONS=(
  "1. System_and_File_Security"
  "2.Installation_and_Planning"
  "4.General_Security"
  # "5.MySQL_Permissions"
  # "7.Authentication"
  # "8.Network_Security"
  # "9.Replication"
  # "10.MySQL_InnoDB_Cluster_Group_Replication"
)

for section in "${SECTIONS[@]}"; do
  echo "========================================"
  echo "Running section: $section"
  echo "========================================"
  ansible-playbook -i "$INVENTORY" "sections/$section/site.yml" -e audit_type="automated" || true
  echo ""
done

echo "========================================"
echo "All sections complete"
echo "========================================"
