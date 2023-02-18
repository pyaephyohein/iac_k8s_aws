locals {
  backend_name = "${var.name}-${var.environment}"
}
terraform {
  backend "s3"{
    key = "vpn.tfstate"
    bucket = "${local.backend_name}-state"
  }
}
data "terraform_remote_state" "environment" {
  backend = "s3"
  config = {
    region = var.region
    bucket = "${var.name}-${var.environment}-state"
    key    = "terraform.tfstate"
  }
}