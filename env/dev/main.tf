module "aws-dev" {
  source         = "../../infra" # path to the infra module
  region_aws     = "us-east-1"
  key            = "iac-DEV"
  instance       = "t2.micro"
  name           = "Server-DEV"
  security_group = "Dev-SG"
  min_size       = 1
  max_size       = 3
  asg_name       = "Dev-ASG"
}
