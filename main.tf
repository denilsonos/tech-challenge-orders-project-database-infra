
provider "aws" {
  region = var.region
}

data "aws_availability_zones" "available" {}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "2.77.0"

  name                 = "fiap"
  cidr                 = "10.0.0.0/16"
  azs                  = data.aws_availability_zones.available.names
  public_subnets       = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
  enable_dns_hostnames = true
  enable_dns_support   = true
}

resource "aws_db_subnet_group" "fiap" {
  name       = "fiap"
  subnet_ids = module.vpc.public_subnets

  tags = {
    Name = "fiap"
  }
}

resource "aws_security_group" "rds" {
  name   = "fiap_rds"
  vpc_id = module.vpc.vpc_id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "fiap_rds"
  }
}

resource "aws_db_parameter_group" "fiap" {
  name   = "fiap"
  family = "mysql8.0"

  parameter {
    name  = "character_set_server"
    value = "utf8"
  }

  parameter {
    name  = "character_set_client"
    value = "utf8"
  }
}

resource "aws_db_instance" "fiap" {
  identifier             = "fiap"
  instance_class         = "db.t3.micro"
  allocated_storage      = 15
  max_allocated_storage  = 30
  engine                 = "mysql"
  engine_version         = "8.0"
  username               = var.db_user
  password               = var.db_password
  db_subnet_group_name   = aws_db_subnet_group.fiap.name
  vpc_security_group_ids = [aws_security_group.rds.id]
  parameter_group_name   = aws_db_parameter_group.fiap.name
  publicly_accessible    = true
  skip_final_snapshot    = true
}