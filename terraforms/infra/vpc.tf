resource "aws_vpc" "k8s_vpc" {
  cidr_block       = var.k8s_vpc_cidr_block
  instance_tenancy = "default"
  enable_dns_hostnames = var.k8s_enable_dns_hostname
  enable_dns_support = var.k8s_enable_dns_support
  tags = {
    Name = "${var.environment}-${var.name}-vpc"
  }
}