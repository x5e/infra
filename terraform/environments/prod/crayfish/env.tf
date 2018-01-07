terraform {
  backend "s3" {
    bucket = "x5e-terraform"
    key    = "prod/crayfish.tfstate"
    region = "us-east-1"
  }
}

module "main" {
  source = "../../../modules/service"
  env_name = "prod"
  service_name = "crayfish"
  has_service = 0
}
