variable "env_name" {}
variable "env_domain" {}
variable "cert_arn" {}
variable "env_region" { default = "us-east-1" }
variable "trusted" {
  default = []
  type = "list"
}

variable "disposable" {}

variable "internal_domain" { default = "x5e.internal" }