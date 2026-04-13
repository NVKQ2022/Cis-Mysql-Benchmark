#!/bin/bash
# Deploy Azure VM with Terraform

cd "$(dirname "$0")"

echo "Logging into Azure..."
#az login

echo "Initializing Terraform..."
terraform init

echo "Deploying VM..."
terraform apply -auto-approve

echo "Getting VM IP..."
terraform output vm_ip
