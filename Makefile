.PHONY: all
all: apply

.PHONY: init
init:
	@terraform init

config.json:
	@./create-config

main.tf: config.json
	@./config-to-tf

.PHONY: fmt
fmt:
	@terraform fmt
	@cd examples/digitalocean-vpn && terraform fmt
	@cd modules/digitalocean-vpn && terraform fmt

.PHONY: plan
plan: main.tf init
	@terraform plan

.PHONY: apply
apply: main.tf init
	@terraform apply

.PHONY: destroy
destroy: init
	@terraform destroy

.PHONY: cp-example
cp-example:
	@cp examples/digitalocean-vpn/*.tf .

.PHONY: run-example
run-example: cp-example apply

.PHONY: clean
clean:
	@rm -f *.tfstate*
	@rm -rf .terraform
