terraform {
  backend "s3" {
    bucket = "082367326120-terraform"
    key    = "qa/crayfish.tfstate"
    region = "us-east-1"
  }
}

module "main" {
  source = "../../../modules/service"
  env_name = "qa"
  service_name = "crayfish"
  has_service = 0
  worker_name = "apprun"
}
