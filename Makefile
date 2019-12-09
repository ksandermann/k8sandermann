
ROOT_DIR := $(shell pwd)
#CHECK_ENV := $(shell exit)
#BACKEND_RESOURCE_GROUP_NAME := $(shell cat $(ROOT_DIR)/terraform/configuration/${CONFIG_NAME}.tfvars | grep backend_resource_group | sed -e 's/backend_resource_group_name = "\(.*\)"/\1/')
#BACKEND_STORAGE_ACCOUNT_NAME := $(shell make check-env)
#BACKEND_STORAGE_CONTAINER_NAME := $(shell pwd)
#BACKEND_KEY := $(shell pwd)

test123:
	@cat $(ROOT_DIR)/terraform/configuration/cluster001.tfvars | grep backend_resource_group | sed -e 's/backend_resource_group_name = "\(.*\)"/\1/'

test234:
	@echo $(CHECK_ENV)


check-env:
ifndef MAKE_WORKSPACE
	$(error - Environment variable MAKE_WORKSPACE is undefined)
endif
ifndef CONFIG_NAME
	$(error - Environment variable CONFIG_NAME is undefined)
endif
ifndef ARM_SUBSCRIPTION_ID
	$(error - Environment variable ARM_SUBSCRIPTION_ID is undefined)
endif
ifndef ARM_TENANT_ID
	$(error - Environment variable ARM_TENANT_ID is undefined)
endif
ifndef ARM_CLIENT_ID
	$(error - Environment variable ARM_CLIENT_ID is undefined)
endif
ifndef ARM_CLIENT_SECRET
	$(error - Environment variable ARM_CLIENT_SECRET is undefined)
endif

#TODO check if config file exists

.ONESHELL:
clean: check-env
	@cd ./terraform/workspaces/${MAKE_WORKSPACE}
	@rm -Rf .terraform

//TODO sed has to except invite space before and after equals sign
.ONESHELL:
init: BACKEND_RESOURCE_GROUP_NAME := $(shell cat $(ROOT_DIR)/terraform/configuration/cluster001.tfvars | grep backend_resource_group | sed -e 's/backend_resource_group_name = "\(.*\)"/\1/')
init: BACKEND_STORAGE_ACCOUNT_NAME:= $(shell cat $(ROOT_DIR)/terraform/configuration/cluster001.tfvars | grep backend_storage_account_name | sed -e 's/backend_storage_account_name = "\(.*\)"/\1/')
init: BACKEND_STORAGE_CONTAINER_NAME:= $(shell cat $(ROOT_DIR)/terraform/configuration/cluster001.tfvars | grep backend_storage_container_name | sed -e 's/backend_storage_container_name = "\(.*\)"/\1/')
init: BACKEND_KEY:= $(shell cat $(ROOT_DIR)/terraform/configuration/cluster001.tfvars | grep aks_cluster_name | sed -e 's/aks_cluster_name = "\(.*\)"/\1/')
init: check-env
	@cd ./terraform/workspaces/${MAKE_WORKSPACE}

	@echo $(BACKEND_RESOURCE_GROUP_NAME)
	@echo $(BACKEND_STORAGE_ACCOUNT_NAME)
	@echo $(BACKEND_STORAGE_CONTAINER_NAME)
	@echo $(BACKEND_KEY)
	#@terraform init \
	#	-backend-config="resource_group_name=$(" \
	#	-backend-config="storage_account_name=$cat $(ROOT_DIR)/terraform/configuration/${CONFIG_NAME}.tfvars | grep backend_storage_account_name | sed -e 's/backend_storage_account_name = "\(.*\)"/\1/')" \
     #   -backend-config="container_name=$(cat $(ROOT_DIR)/terraform/configuration/${CONFIG_NAME}.tfvars | grep backend_storage_container_name | sed -e 's/backend_storage_container_name = "\(.*\)"/\1/')" \
      #  -backend-config="key=$(cat $(ROOT_DIR)/terraform/configuration/${CONFIG_NAME}.tfvars | grep aks_cluster_name | sed -e 's/aks_cluster_name = "\(.*\)"/\1/')"


force-init: clean init

.ONESHELL:
update-modules: init
	@cd ./terraform/workspaces/${MAKE_WORKSPACE}
	@terraform get -update

.ONESHELL:
fmt:
	@cd ./terraform/workspaces/${MAKE_WORKSPACE}
	@terraform fmt -recursive

.ONESHELL:
validate: update-modules fmt
	@cd ./terraform/workspaces/${MAKE_WORKSPACE}
	@terraform validate

.ONESHELL:
dismiss-plan:
	@cd ./terraform/workspaces/${MAKE_WORKSPACE}
	@rm -f "$(PLAN_FILE)"

.ONESHELL:
check-plan-exists:
	@cd ./terraform/workspaces/${MAKE_WORKSPACE}
	@if [ ! -f "${CONFIG_NAME}.plan" ]; then echo "Plan is missing. Please create one first."; exit 1; fi

.ONESHELL:
plan: validate
	@cd ./terraform/workspaces/${MAKE_WORKSPACE}
	@terraform plan \
		-var-file $(ROOT_DIR)/terraform/configuration/${CONFIG_NAME}.tfvars \
		-out ${CONFIG_NAME}.plan \
		-state=./${CONFIG_NAME}.tfstate

force-plan: dismiss-plan plan

.ONESHELL:
plan-destroy: dismiss-plan validate
	@cd ./terraform/workspaces/${MAKE_WORKSPACE}
	@terraform plan \
		-var-file $(ROOT_DIR)/terraform/configuration/${CONFIG_NAME}.tfvars \
		-out ${CONFIG_NAME}.plan \
		-state=./${CONFIG_NAME}.tfstate \
		-destroy


.ONESHELL:
apply: check-plan-exists
	@cd ./terraform/workspaces/${MAKE_WORKSPACE}
	@terraform apply \
		-state=./${CONFIG_NAME}.tfstate \
		${CONFIG_NAME}.plan

.ONESHELL:
force-apply: check-plan-exists
	@cd ./terraform/workspaces/${MAKE_WORKSPACE}
	@terraform apply \
		-state=./${CONFIG_NAME}.tfstate \
		-auto-approve \
		${CONFIG_NAME}.plan \

kubectl-backup-config:
	@mv -f ~/.kube/config ~/.kube/config_backup.yaml || true

kubectl-restore-config:
	@mv -f ~/.kube/config_backup.yaml ~/.kube/config || true

az-logout:
	@az logout || true

.ONESHELL:
az-login: check-env az-logout
	@echo "Logging in to Azure..."
	@az login --service-principal --username "${ARM_CLIENT_ID}" --password "${ARM_CLIENT_SECRET}" --tenant "${ARM_TENANT_ID}"
	@echo "Setting Subscription to ${ARM_SUBSCRIPTION_ID}..."
	@az account set -s ${ARM_SUBSCRIPTION_ID}

#TODO get rg and cluster from tf output
kubectl-get-config: az-login
	@az aks get-credentials --name pipelineCluster001 --resource-group pipelineCluster001 --subscription ${ARM_SUBSCRIPTION_ID} --admin --overwrite-existing


.DEFAULT_GOAL := default
default: init validate
