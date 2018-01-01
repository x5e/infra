terraform {
  backend "s3" {
    bucket = "x5e-terraform"
    key    = "prod/shared.tfstate"
    region = "us-east-1"
  }
}

module "main" {
  source = "../../../modules/shared"
  env_name = "prod"
  disposable = "false"
  env_domain = "x5e.com"
  cert_arn = "arn:aws:acm:us-east-1:401701269211:certificate/835a1f34-1d56-4668-9d58-86794576331b"
  trusted = ["69.162.169.108/32", "172.26.0.0/16"]
}

