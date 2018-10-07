terraform {
  backend "s3" {
    bucket = "082367326120-terraform"
    key    = "qa/cloud.tfstate"
    region = "us-east-1"
  }
}

module "main" {
  source = "../../../modules/service"
  env_name = "qa"
  service_name = "cloud"
  has_service = 0
  worker_name = "puffer"
}
