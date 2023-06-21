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

resource "aws_launch_template" "server_instante" {
  image_id      = "ami-053b0d53c279acc90"
  instance_type = var.instance
  key_name      = var.key
  tags = {
    Name = var.name
  }
  security_group_names = [var.security_group]
}

resource "aws_key_pair" "chaveSSH" {
  key_name   = var.key
  public_key = file("${var.key}.pub")
}

output "ip_publico" {
  value = aws_instance.app_server.public_ip
}

