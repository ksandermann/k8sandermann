#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

#needs to be contributor in subscription & manage Applications in AAD
#quick & superdirty: Owner & User Access Administrator in Subscription IAM, Global Administrator in Azure AD Role Assignments
#az ad sp create-for-rbac -n "terraform" --role contributor --scopes /subscriptions/${ARM_SUBSCRIPTION_ID} --years 3
export ARM_CLIENT_ID=""
export ARM_CLIENT_SECRET=""
export ARM_SUBSCRIPTION_ID=""
export ARM_TENANT_ID=""

export CONFIG_NAME="cluster001"


make az-logout

###workspace azurerm-backend
export MAKE_WORKSPACE="azurerm-backend"
make force-init plan force-apply



#workspace aks-cluster
export MAKE_WORKSPACE="aks-cluster"
#run this twice to ensure Azure AD registered service principal before attempting to create cluster
make force-init plan force-apply || true
make force-init plan force-apply

#has to be called within aks-cluster workspace
make kubectl-get-config kubectl-backup-config


###TODO move this
#workspace k8s
apt-get install -y zip
###has to be relative path
zip -r ansible.zip ./ansible/*

export MAKE_WORKSPACE="k8s"
make force-init plan force-apply
make kubectl-restore-config



COUNTER=0
while [  $COUNTER -lt 100 ];
do
    jobstatus=$(kubectl get jobs --all-namespaces  -o jsonpath='{.items[*].status.conditions[].status}')
    if [[ $jobstatus == *"False"* ]]; then
    echo "Iteration $COUNTER - Jobs still running!"
    let COUNTER=COUNTER+1
    sleep 3
    else
    kubectl get jobs --all-namespaces -o wide
    echo "Iteration $COUNTER - All Jobs have True status!"
    let COUNTER=100
    fi
done

export MAKE_WORKSPACE="aks-cluster"
make force-init plan-destroy force-apply
