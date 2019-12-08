#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

AZURE_SUBSCRIPTION="3fb6e3d6-f485-4cac-ae04-b06c555c3e6d"
K8SANDERMANN_CONFIGURATION="cluster001"

#az login

#PayPerUse-Privat
az account set -s ${AZURE_SUBSCRIPTION}

#az ad sp create-for-rbac -n "tf-k8sandermann" --role contributor --scopes /subscriptions/${AZURE_SUBSCRIPTION} --years 3

cd /root/project/terraform/
terraform fmt -recursive

#AKS-Cluster
cd /root/project/terraform/workspaces/aks-cluster
rm -rf ./terraform *.plan
terraform init
terraform get -update
terraform validate
terraform plan \
  -var-file=/root/project/terraform/configuration/${K8SANDERMANN_CONFIGURATION}.tfvars \
  -out=./${K8SANDERMANN_CONFIGURATION}.plan
terraform apply \
  -state=./${K8SANDERMANN_CONFIGURATION}.tfstate \
  ./${K8SANDERMANN_CONFIGURATION}.plan

#K8S-BASE
apt-get install -y zip
cd /root/project
#has to be relative path
zip -r ansible.zip ./ansible/*
rm -rf /root/.kube/config

cd /root/project/terraform/workspaces/k8s-base
mv -f /root/.kube/config /root/.kube/backup.yaml
terraform init
terraform get -update
terraform validate
terraform plan \
  -state=./${K8SANDERMANN_CONFIGURATION}.tfstate \
  -var-file=/root/project/terraform/configuration/${K8SANDERMANN_CONFIGURATION}.tfvars \
  -out=./${K8SANDERMANN_CONFIGURATION}.plan
terraform apply \
  -state=./${K8SANDERMANN_CONFIGURATION}.tfstate \
  ./${K8SANDERMANN_CONFIGURATION}.plan

az aks get-credentials --name cicd-cluster001 --resource-group cicd-cluster001 --subscription 3fb6e3d6-f485-4cac-ae04-b06c555c3e6d --admin --overwrite-existing
kubectl get cm



#K8S-JOBS
mv -f /root/.kube/config /root/.kube/backup.yaml
cd /root/project/terraform/workspaces/k8s-jobs
rm -rf ./terraform *.plan
terraform init
terraform get -update
terraform validate
terraform plan \
  -state=./${K8SANDERMANN_CONFIGURATION}.tfstate \
  -var-file=/root/project/terraform/configuration/${K8SANDERMANN_CONFIGURATION}.tfvars \
  -out=./${K8SANDERMANN_CONFIGURATION}.plan
terraform apply \
  -state=./${K8SANDERMANN_CONFIGURATION}.tfstate \
  ./${K8SANDERMANN_CONFIGURATION}.plan

az aks get-credentials --name cicd-cluster001 --resource-group cicd-cluster001 --subscription 3fb6e3d6-f485-4cac-ae04-b06c555c3e6d --admin --overwrite-existing
kubectl get pods --all-namespaces
