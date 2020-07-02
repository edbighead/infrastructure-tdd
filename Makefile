TFPLAN = tfplan

unit:
	tflint main.tf
	conftest test -p test/conftest/vpc.rego main.tf
	conftest test -p test/conftest/subnet.rego main.tf
	conftest test -p test/conftest/ec2.rego main.tf

contract:
	terraform plan -out $(TFPLAN)
	terraform show -json $(TFPLAN) > $(TFPLAN).json
	conftest test -p test/conftest/subnet-contract.rego $(TFPLAN).json

integration:
	cd test/terratest; go test -timeout 20m -v -run TestTerraformAwsRds

cost:
	./test/cost/check.sh "10.0"
