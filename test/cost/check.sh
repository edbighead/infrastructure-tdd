#!/bin/sh
MONTHLY_BUDGET=$1
FORECASTED_MONTHLY_COST=$(terraform plan -out=plan.tfplan > /dev/null \
                          && terraform show -json plan.tfplan | \
                          curl -s -X POST -H "Content-Type: application/json" -d @- https://cost.modules.tf/ | \
                          jq .monthly)

if [ `echo "$FORECASTED_MONTHLY_COST>$MONTHLY_BUDGET"|bc` -eq 1 ]; then
  echo "Forecasted EC2 monthly cost ($FORECASTED_MONTHLY_COST\$) is greater than EC2 monthly budget ($MONTHLY_BUDGET\$)"
  exit 1
else
  echo "Forecasted EC2 monthly cost ($FORECASTED_MONTHLY_COST\$) is less than EC2 monthly budget ($MONTHLY_BUDGET\$)"
fi
