
provider "aws" {
  region = var.region
}

# Este bloco é opcional se você estiver apenas usando a VPC padrão sem necessidade de referenciá-la explicitamente
data "aws_vpc" "default" {
  default = true
}

resource "aws_default_security_group" "default" {
  vpc_id = data.aws_vpc.default.id
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

resource "aws_db_instance" "mysql_db_instance" {
  identifier             = "mysqldbinstance"
  instance_class         = "db.t3.micro"
  allocated_storage      = 15
  max_allocated_storage  = 30
  db_name                = var.db_name
  engine                 = "mysql"
  engine_version         = "8.0"
  username               = var.db_user
  password               = var.db_password
  publicly_accessible    = true # change to false in prod
  skip_final_snapshot    = true
  vpc_security_group_ids = [aws_default_security_group.default.id]
}
