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
  region = "us-east-1"
}

resource "aws_instance" "app_server" {
  ami                         = "ami-053b0d53c279acc90"
  instance_type               = "t2.micro"
  key_name                    = "terraform-aws"
  user_data_replace_on_change = true
  tags = {
    Name = "Terraform Ansible Python"
  }
  security_groups = ["acesso-ssh", "acesso-total"]
}


