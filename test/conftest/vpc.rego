package main

deny[msg] {
  not contains(input.resource.aws_vpc.main.cidr_block, "var.vpc_cidr")
  msg = "VPC CIDR Block should use `var.vpc_cidr` variable"
}