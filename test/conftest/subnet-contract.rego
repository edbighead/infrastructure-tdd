package main

deny[msg] {
  subnets := [r | r := input.planned_values.root_module.resources[_]; r.address == "aws_subnet.private"]
  subnets[0].values.cidr_block != "10.1.2.0/24"
  msg = sprintf("Private subnet has wrong CIDR: `%v`", [subnets[0].values.cidr_block])
}

deny[msg] {
  subnets := [r | r := input.planned_values.root_module.resources[_]; r.address == "aws_subnet.public"]
  subnets[0].values.cidr_block != "10.1.1.0/24"
  msg = sprintf("Private subnet has wrong CIDR: `%v`", [subnets[0].values.cidr_block])
}