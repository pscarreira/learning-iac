module "aws-prd" {
  source     = "../../infra" # path to the infra module
  region_aws = "us-east-1"
  key        = "iac-PRD"
  instance   = "t2.micro"
  name       = "Server-PRD"
}

