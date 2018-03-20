terraform {
  backend "s3" {
    bucket = "082367326120-terraform"
    key    = "qa/camera.tfstate"
    region = "us-east-1"
  }
}

module "main" {
  source = "../../../modules/service"
  env_name = "qa"
  service_name = "camera"
  service_port = "2020"
  branch = "dev"
}
