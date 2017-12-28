terraform {
  backend "s3" {
    bucket = "x5e-terraform"
    key    = "prod/shared.tfstate"
    region = "us-east-1"
  }
}

module "main" {
  source = "../../../modules/main"
  env_name = "prod"
  env_region = "us-east-1"
  disposable = "true"
  env_domain = "x5e.com"
  cert_arn = "arn:aws:acm:us-east-1:401701269211:certificate/835a1f34-1d56-4668-9d58-86794576331b"
}

