terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = var.region_aws
}

resource "aws_instance" "app_server" {
  ami           = "ami-053b0d53c279acc90"
  instance_type = var.instance
  key_name      = var.key
  tags = {
    Name = var.name
  }
  vpc_security_group_ids = [aws_security_group.acesso_geral.id]
}

resource "aws_key_pair" "chaveSSH" {
  key_name   = var.key
  public_key = file("${var.key}.pub")
}

output "ip_publico" {
  value = aws_instance.app_server.public_ip
}

