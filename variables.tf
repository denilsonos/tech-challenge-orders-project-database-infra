
variable "region" {
  default     = "us-east-1"
  description = "AWS region"
}

variable "db_user" {
  description = "RDS username"
  sensitive   = true
}

variable "db_password" {
  description = "RDS user password"
  sensitive   = true
}