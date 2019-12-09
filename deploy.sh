#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

#needs to be contributor in subscription & manage Applications in AAD
#quick & superdirty: Owner & User Access Administrator in Subscription IAM, Global Administrator in Azure AD Role Assignments
#az ad sp create-for-rbac -n "terraform" --role contributor --scopes /subscriptions/${ARM_SUBSCRIPTION_ID} --years 3
export ARM_CLIENT_ID="a89f96ae-87c6-4244-a0ec-5166096ba980"
export ARM_CLIENT_SECRET="46942eff-7a16-437e-9466-a6b76c58747a"
export ARM_SUBSCRIPTION_ID="3fb6e3d6-f485-4cac-ae04-b06c555c3e6d"
export ARM_TENANT_ID="630b4926-3eee-47e5-b0c1-1dd833cb304a"

make az-logout
#workspace aks-cluster
export MAKE_WORKSPACE="aks-cluster"
export CONFIG_NAME="cluster001"
#run this twice to ensure Azure AD registered service principal before attempting to create cluster
make force-init plan force-apply || true
make force-init plan force-apply
make kubectl-get-config kubectl-backup-config


#TODO move this
#workspace k8s
apt-get install -y zip
#has to be relative path
zip -r ansible.zip ./ansible/*

export MAKE_WORKSPACE="k8s"
export CONFIG_NAME="cluster001"
make force-init plan force-apply
make kubectl-restore-config

kubectl get pods --all-namespaces
kubectl get cm --all-namespaces

