package test

import (
	"fmt"
	"strings"
	"testing"
	"strconv"

	"github.com/gruntwork-io/terratest/modules/aws"
	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestTerraformAwsRds(t *testing.T) {
	t.Parallel()

	// Give this RDS Instance a unique ID for a name tag so we can distinguish it from any other RDS Instance running
	// in your AWS account
	expectedName := fmt.Sprintf("terratest-aws-rds-%s", strings.ToLower(random.UniqueId()))
	awsRegion := "us-east-1"

	terraformOptions := &terraform.Options{
		// The path to where our Terraform code is located
		TerraformDir: "../../",

		// Variables to pass to our Terraform code using -var options
		// "username" and "password" should not be passed from here in a production scenario.
		Vars: map[string]interface{}{
			"db_name": expectedName,
		},

		// Environment variables to set when running Terraform
		EnvVars: map[string]string{
			"AWS_DEFAULT_REGION": awsRegion,
		},
	}

	// At the end of the test, run `terraform destroy` to clean up any resources that were created
	defer terraform.Destroy(t, terraformOptions)

	// This will run `terraform init` and `terraform apply` and fail the test if there are any errors
	terraform.InitAndApply(t, terraformOptions)

	// Run `terraform output` to get the value of an output variable
	dbInstanceID := terraform.Output(t, terraformOptions, "db_instance_id")

	// Run `terraform output` to get the value of an output variable
	sgFromPort := terraform.Output(t, terraformOptions, "rds_sg_port")
	// Look up the endpoint address and port of the RDS instance
	port := strconv.FormatInt(aws.GetPortOfRdsInstance(t, dbInstanceID, awsRegion), 10)

	assert.Equal(t, sgFromPort, port)
}
