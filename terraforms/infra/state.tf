locals {
  backend_name                = "${var.name}-${var.environment}"
}
terraform {
  backend "s3"{
    key = "terraform.tfstate"
    bucket = "${local.backend_name}-state"
  }
}