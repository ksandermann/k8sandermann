#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

#PayPerUse-Privat
AZURE_SUBSCRIPTION="3fb6e3d6-f485-4cac-ae04-b06c555c3e6d"

#az login


az account set -s ${AZURE_SUBSCRIPTION}

#az ad sp create-for-rbac -n "tf-k8sandermann" --role contributor --scopes /subscriptions/${AZURE_SUBSCRIPTION} --years 3

terraform fmt -recursive

#workspace aks-cluster
export MAKE_WORKSPACE="aks-cluster"
export CONFIG_NAME="cluster001"
make force-init plan
make force-apply


#workspace k8s
apt-get install -y zip
cd /root/project
#has to be relative path
zip -r ansible.zip ./ansible/*

mv -f /root/.kube/config /root/.kube/backup.yaml || true

export MAKE_WORKSPACE="k8s"
export CONFIG_NAME="cluster001"
make force-init plan
make force-apply


az aks get-credentials --name pipelineCluster001 --resource-group pipelineCluster001 --subscription 3fb6e3d6-f485-4cac-ae04-b06c555c3e6d --admin --overwrite-existing
kubectl get pods --all-namespaces
kubectl get cm

