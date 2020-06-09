unit:
	tflint main.tf
	conftest test -p test/conftest/vpc.rego main.tf
	conftest test -p test/conftest/subnet.rego main.tf
	# conftest test -p test/conftest/ec2.rego main.tf