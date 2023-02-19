name="testing"
environment="dev"
region="ap-southeast-1"
vpn_instance_size="t2.micro"
master_count=1
master_size="t2.medium"
worker_count=2
worker_size="t2.small"
ssh_key_pair="mgou@mac"
k8s_vpc_cidr_block="172.16.0.0/16"
k8s_enable_dns_hostname="true"
k8s_enable_dns_support="true"
k8s_public_subnets_cidr=["172.16.1.0/24"]
k8s_private_subnets_cidr=["172.16.10.0/24"]
availability_zone=["ap-southeast-1a","ap-southeast-1b"]

