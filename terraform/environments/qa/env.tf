variable "env_region" {
  default = "us-east-1"
}

terraform {
  backend "s3" {
    bucket = "082367326120-terraform"
    key    = "qa"
    region = "us-east-1"
  }
}

provider "aws" {
  region = "${var.env_region}"
  allowed_account_ids = ["082367326120"]
}


module "main" {
  source = "../../modules/main"
  env_name = "qa"
  env_region = "${var.env_region}"
  env_domain = "x5e.qa"
  disposable = "true"
  cert_arn = "arn:aws:acm:us-east-1:082367326120:certificate/4af129a1-9ca3-4c1b-8928-0e4a4896b1b2"
}

output "db_password" { value = "${module.main.db_password}" }
