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

resource "aws_launch_template" "server_instance_dev" {
  image_id      = "ami-053b0d53c279acc90"
  instance_type = var.instance
  key_name      = var.key
  tags = {
    Name = var.name
  }
  vpc_security_group_ids = [aws_security_group.acesso_geral.id]
  user_data              = filebase64("ansible.sh")
}

resource "aws_key_pair" "chaveSSH" {
  key_name   = var.key
  public_key = file("${var.key}.pub")
}

resource "aws_autoscaling_group" "dev_asg" {
  availability_zones = ["${var.region_aws}a", "${var.region_aws}b"]
  name               = var.asg_name
  max_size           = var.max_size
  min_size           = var.min_size
  launch_template {
    id      = aws_launch_template.server_instance_dev.id
    version = "$Latest"
  }
  target_group_arns = [aws_lb_target_group.target_group_dev.arn]
}

resource "aws_default_subnet" "subnet_1_dev" {
  availability_zone = "${var.region_aws}a"
}

resource "aws_default_subnet" "subnet_2_dev" {
  availability_zone = "${var.region_aws}b"
}

resource "aws_lb" "load_balancer_dev" {
  internal = false
  subnets  = [aws_default_subnet.subnet_1_dev.id, aws_default_subnet.subnet_2_dev.id]
  //security_groups = [aws_security_group.acesso_geral.id]
}

resource "aws_default_vpc" "vpc_default_dev" {}

resource "aws_lb_target_group" "target_group_dev" {
  name     = "target-group-dev"
  port     = "8000"
  protocol = "HTTP"
  vpc_id   = aws_default_vpc.vpc_default_dev.id
}

resource "aws_lb_listener" "listener_load_balancer" {
  load_balancer_arn = aws_lb.load_balancer_dev.arn
  port              = "8000"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group_dev.arn
  }
}
