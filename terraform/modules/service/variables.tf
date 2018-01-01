variable "service_name" {}
variable "env_name" {}

variable "region" { default = "us-east-1"}
variable "service_port" { default = 8080 }
variable "cpu" { default = 1 }
variable "memory" { default = 256 }
variable "network_mode" { default = "host"}
variable "service_count" { default = 1 }
variable "need_s3_bucket" { default = 0 }