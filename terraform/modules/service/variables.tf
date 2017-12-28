variable "service_name" {}
variable "env_name" {}

variable "region" { default = "us-east-1"}
variable "service_port" { default = 8080 }
variable "cpu" { default = 128 }
variable "memory" { default = 128 }
variable "network_mode" { default = "host"}
variable "service_count" { default = 1 }
