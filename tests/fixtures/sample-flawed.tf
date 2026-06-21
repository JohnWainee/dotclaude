# App data store + access role.
# (Fixture for exercising adversarial-review-iac.md — contains planted defects.)

terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_db_instance" "app" {
  identifier          = "app-db"
  engine              = "postgres"
  instance_class      = "db.t3.micro"
  allocated_storage   = 20
  username            = "appadmin"
  password            = "Sup3rSecret-db-pw"
  publicly_accessible = true
  skip_final_snapshot = true
}

resource "aws_security_group" "db" {
  name = "app-db-sg"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_iam_role_policy" "app" {
  name = "app-policy"
  role = "app-role"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect   = "Allow"
      Action   = "*"
      Resource = "*"
    }]
  })
}

output "db_password" {
  value = aws_db_instance.app.password
}
