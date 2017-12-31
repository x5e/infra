
terraform {
  backend "s3" {
    bucket = "082367326120-terraform"
    key    = "qa/shared.tfstate"
    region = "us-east-1"
  }
}


module "shared" {
  source = "../../../modules/shared"
  env_name = "qa"
  env_domain = "x5e.qa"
  cert_arn = "arn:aws:acm:us-east-1:082367326120:certificate/4af129a1-9ca3-4c1b-8928-0e4a4896b1b2"
  disposable = true
  trusted = ["69.162.169.108/32", "34.199.230.121/32"]
}

