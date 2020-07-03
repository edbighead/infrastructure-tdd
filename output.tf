output "rds_sg_port" {
  value       = aws_security_group_rule.rds_ingress.from_port
}

output "db_instance_id" {
  value       = aws_db_instance.default.id
}

