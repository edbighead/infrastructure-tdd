variable "env" {
  type        = string
  default     = "test"
  description = "environment"
}

variable "vpc_cidr" {
  type        = string
  default     = "10.1.0.0/16"
  description = "VPC CIDR block"
}
