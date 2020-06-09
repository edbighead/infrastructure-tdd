package main

deny[msg] {
  not re_match(".*public", input.resource.aws_subnet.public.tags.Name)
  msg = "Public subnet name does does not contain public prefix"
}