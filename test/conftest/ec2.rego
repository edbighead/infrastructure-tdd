package main

deny[msg] {
  not input.resource.aws_instance.web.tags.Env
  msg = "Instance should have Env tag"
}