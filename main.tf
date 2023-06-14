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
  profile = "default"
  region  = "us-east-1"
}

resource "aws_instance" "app_server" {
  ami           = "ami-053b0d53c279acc90"
  instance_type = "t2.micro"
  key_name      = "terraform-aws"
  user_data     = <<-EOF
  #!/bin/bash
  cd /home/ubuntu
  echo "<h1>Feito com Terraform</h1>" > index.html
  nohup busybox httpd -f -p 8080 &
  EOF

  user_data_replace_on_change = true
  tags = {
    Name = "Teste AWS"
  }
  security_groups = ["acesso-ssh", "acesso-total"]
}
