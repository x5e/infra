terraform {
  backend "s3" {
    bucket = "082367326120-terraform"
    key    = "qa-latency"
    region = "us-east-1"
  }
}

module "main" {
  source = "../../modules/service"
  env_name = "qa"
  service_name = "latency"
  service_port = "1234"
  account_id = "082367326120"
}
