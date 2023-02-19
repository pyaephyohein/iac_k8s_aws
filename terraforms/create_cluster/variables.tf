variable "name" {
  description = "name of your infra"
  type = string
}
variable "environment" {
  description = "name of environment"
  type = string
}
variable "region" {
  description = "region of aws"
  type = string
}
variable "master_count" {
  description = "count of master node"
  type = number
}
variable "worker_count" {
  description = "count of worker node"
  type = number
}
variable "master_size" {
  description=  "instance size of master node"
  type = string
}
variable "worker_size" {
  description = "instance size of worker node"
  type = string
}
variable "k8s_enable_dns_hostname" {
  description = "use dns hostname"
  type = bool
}
variable "k8s_enable_dns_support" {
  description = "use dns support"
  type = bool
}
variable "k8s_vpc_cidr_block" {
  description = "vpc_cidr block"
  type = string
}
variable "k8s_public_subnets_cidr" {
  description = "public subnet cidr"
  type = list(string)
}
variable "k8s_private_subnets_cidr" {
  description = "private subnet cidr"
  type = list(string)
}
variable "availability_zone" {
  description = "availability_zone"
  type = list(string)
}
variable "vpn_instance_size" {
  description = "size of vpn server"
  type = string
}
variable "ssh_key_pair" {
  description = "key_pair name"
  type = string
}