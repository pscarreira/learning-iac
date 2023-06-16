module "aws-dev" {
  source     = "../../infra" # path to the infra module
  region_aws = "us-east-1"
  key        = "iac-DEV"
  instance   = "t2.micro"
  name       = "Server-DEV"
}

output "ip" {
  value = module.aws-dev.ip_publico
}
