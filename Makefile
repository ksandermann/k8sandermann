ROOT_DIR := $(shell pwd)
WORKSPACE_CONFIG_NAME = ${CONFIG_NAME}

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


.ONESHELL:
init: BACKEND_RESOURCE_GROUP_NAME:= $(shell cat $(ROOT_DIR)/terraform/configuration/$(WORKSPACE_CONFIG_NAME).tfvars | grep backend_resource_group | sed -e 's/backend_resource_group_name\s=\s"\(.*\)"/\1/')
init: BACKEND_STORAGE_ACCOUNT_NAME:= $(shell cat $(ROOT_DIR)/terraform/configuration/$(WORKSPACE_CONFIG_NAME).tfvars | grep backend_storage_account_name | sed -e 's/backend_storage_account_name\s=\s"\(.*\)"/\1/')
init: BACKEND_STORAGE_CONTAINER_NAME:= $(shell cat $(ROOT_DIR)/terraform/configuration/$(WORKSPACE_CONFIG_NAME).tfvars | grep backend_storage_container_name | sed -e 's/backend_storage_container_name\s=\s"\(.*\)"/\1/')
init: check-env
	@cd ./terraform/workspaces/${MAKE_WORKSPACE}
	@terraform init \
		-backend-config="resource_group_name=$(BACKEND_RESOURCE_GROUP_NAME)" \
		-backend-config="storage_account_name=$(BACKEND_STORAGE_ACCOUNT_NAME)" \
        -backend-config="container_name=$(BACKEND_STORAGE_CONTAINER_NAME)"


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
		-out ${CONFIG_NAME}.plan

force-plan: dismiss-plan plan

.ONESHELL:
plan-destroy: dismiss-plan validate
	@cd ./terraform/workspaces/${MAKE_WORKSPACE}
	@terraform plan \
		-var-file $(ROOT_DIR)/terraform/configuration/${CONFIG_NAME}.tfvars \
		-out ${CONFIG_NAME}.plan \
		-destroy


.ONESHELL:
apply: check-plan-exists
	@cd ./terraform/workspaces/${MAKE_WORKSPACE}
	@terraform apply \
		${CONFIG_NAME}.plan

.ONESHELL:
force-apply: check-plan-exists
	@cd ./terraform/workspaces/${MAKE_WORKSPACE}
	@terraform apply \
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

.ONESHELL:
kubectl-get-config: init az-login
	@az aks get-credentials --name $(shell cd $(ROOT_DIR)/terraform/workspaces/${MAKE_WORKSPACE} && terraform output aks_cluster_name) --resource-group $(shell cd $(ROOT_DIR)/terraform/workspaces/${MAKE_WORKSPACE} && terraform output aks_resource_group_name) --subscription ${ARM_SUBSCRIPTION_ID} --admin --overwrite-existing


.DEFAULT_GOAL := default
default: init validate
