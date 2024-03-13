
provider "aws" {
  region = var.region
}

data "aws_availability_zones" "available" {}

resource "aws_db_subnet_group" "db_subnet" {
  name       = "db_subnet"
  subnet_ids = module.vpc.public_subnets

  tags = {
    Name = "DB Subnet"
  }
}

resource "aws_security_group" "rds" {
  name   = "rds"
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
    Name = "RDS Mysql"
  }
}

resource "aws_db_parameter_group" "db_params" {
  name   = "dbparams"
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

resource "aws_db_instance" "mysql_db_instance" {
  identifier             = "mysqldbinstance"
  instance_class         = "db.t3.micro"
  allocated_storage      = 15
  max_allocated_storage  = 30
  engine                 = "mysql"
  engine_version         = "8.0"
  username               = var.db_user
  password               = var.db_password
  db_subnet_group_name   = aws_db_subnet_group.db_subnet.name
  vpc_security_group_ids = [aws_security_group.rds.id]
  parameter_group_name   = aws_db_parameter_group.db_params.name
  publicly_accessible    = true # change to false in prod
  skip_final_snapshot    = true
}
