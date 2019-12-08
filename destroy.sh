#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

AZURE_SUBSCRIPTION="3fb6e3d6-f485-4cac-ae04-b06c555c3e6d"
K8SANDERMANN_CONFIGURATION="cluster001"

#az login

#PayPerUse-Privat
az account set -s ${AZURE_SUBSCRIPTION}

rm -rf /root/project/ansible.zip

cd /root/project/terraform/workspaces/aks-cluster
rm -rf ./terraform
terraform init
terraform get -update
terraform validate
terraform destroy \
  -var-file=/root/project/terraform/configuration/${K8SANDERMANN_CONFIGURATION}.tfvars \
  -state=./${K8SANDERMANN_CONFIGURATION}.tfstate
