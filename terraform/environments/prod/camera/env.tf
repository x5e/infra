terraform {
  backend "s3" {
    key    = "prod/camera.tfstate"
    region = "us-east-1"
    bucket = "x5e-terraform"
  }
}

module "main" {
  source = "../../../modules/service"
  env_name = "prod"
  service_name = "camera"
  service_port = "2020"
  branch = "master"
}
