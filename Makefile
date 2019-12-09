clean:
	@rm -Rf .terraform

init:
	@terraform init

force-init: clean init

update-modules: init
	@terraform get -update

fmt:
	@terraform fmt -recursive

validate: update-modules fmt
	@terraform validate

dismiss-plan:
	@rm -f "$(PLAN_FILE)"

check-plan-exists:
	@if [ ! -f "$(PLAN_FILE)" ]; then echo "Plan is missing. Please create one first."; exit 1; fi

plan: validate
	@terraform plan -var-file $(VAR_FILE) -out $(PLAN_FILE)

force-plan: dismiss-plan plan

plan-destroy: dismiss-plan validate
	@terraform plan -var-file $(VAR_FILE) -out $(PLAN_FILE)

apply: check-plan-exists
	@terraform apply $(PLAN_FILE)

force-apply: check-plan-exists
	terraform apply -var-file $(VAR_FILE) -auto-approve


.DEFAULT_GOAL := default
default: init validate
