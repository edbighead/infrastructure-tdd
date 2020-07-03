package main

deny[msg] {
  not re_match(".*public", input.resource.aws_subnet.public.tags.Name)
  msg = "Public subnet name does does not contain public prefix"
}

deny[msg] {
  not re_match(".*private", input.resource.aws_subnet.private.tags.Name)
  msg = "Private subnet name does does not contain private prefix"
}