resource "aws_db_instance" "default" {
  identifier = var.db_name
  allocated_storage    = 20
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t2.micro"
  name                 = "mydb"
  username             = "foo"
  password             = "foobarbaz"
  parameter_group_name = "default.mysql5.7"
  vpc_security_group_ids = [aws_security_group.public_subnet_access.id]
  db_subnet_group_name = aws_db_subnet_group.default.id
  skip_final_snapshot = true
}

resource "aws_db_subnet_group" "default" {
  name       = "main"
  subnet_ids = [aws_subnet.private.id, aws_subnet.public.id]

  tags = {
    Name = "DB subnet group"
  }
}

resource "aws_security_group" "public_subnet_access" {
  name        = "public_subnet_access"
  description = "Allow traffic from public subnet"
  vpc_id      = aws_vpc.main.id
}

resource "aws_security_group_rule" "rds_ingress" {
  type              = "ingress"
  from_port         = 3306
  to_port           = 3306
  protocol          = "tcp"
  cidr_blocks       = [aws_subnet.public.cidr_block]
  security_group_id = aws_security_group.public_subnet_access.id
}

resource "aws_security_group_rule" "rds_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "tcp"
  cidr_blocks       = [aws_subnet.public.cidr_block]
  security_group_id = aws_security_group.public_subnet_access.id
}