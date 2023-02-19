locals {
  backend_name = "${var.name}-${var.environment}"
}
terraform {
  backend "s3"{
    key = "cluster.tfstate"
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
# resource "aws_s3_bucket_object" "kubeconfig" {
#   depends_on = [
#     resource.local_file.ansible_inventory
#   ]
#   bucket = "${var.name}-${var.environment}-state"
#   key    = "kubeconfig"
#   source = "./kubeconfig"