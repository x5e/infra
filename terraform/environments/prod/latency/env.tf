terraform {
  backend "s3" {
    bucket = "x5e-terraform"
    key    = "prod/latency.tfstate"
    region = "us-east-1"
  }
}

module "main" {
  source = "../../../modules/service"
  env_name = "prod"
  service_name = "latency"
  service_port = "1234"
}
