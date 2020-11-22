.PHONY: init
init:
	@terraform init

.PHONY: fmt
fmt:
	@terraform fmt
	@cd examples/digitalocean-vpn && terraform fmt
	@cd modules/digitalocean-vpn && terraform fmt

.PHONY: plan
plan: init
	@terraform plan -var-file=my.tfvars

.PHONY: apply
apply: init
	@terraform apply -var-file=my.tfvars

.PHONY: destroy
destroy: init
	@terraform destroy -var-file=my.tfvars

.PHONY: cp-example
cp-example:
	@cp examples/digitalocean-vpn/*.tf .

.PHONY: run-example
run-example: cp-example apply

.PHONY: clean
clean:
	@rm -f *.tfstate*
	@rm -rf .terraform
