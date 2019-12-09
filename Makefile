
ROOT_DIR := $(shell pwd)

check-env:
ifndef MAKE_WORKSPACE
	$(error - Environment variable MAKE_WORKSPACE is undefined)
endif
ifndef CONFIG_NAME
	$(error - Environment variable CONFIG_NAME is undefined)
endif

#TODO check if config file exists

.ONESHELL:
clean: check-env
	@cd ./terraform/workspaces/${MAKE_WORKSPACE}
	@rm -Rf .terraform

.ONESHELL:
init: check-env
	@cd ./terraform/workspaces/${MAKE_WORKSPACE}
	@terraform init

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


.DEFAULT_GOAL := default
default: init validate
