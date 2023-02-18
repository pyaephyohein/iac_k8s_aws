resource "aws_instance" "vpn" {
  ami           = "ami-055d15d9cfddf7bd3"
  instance_type = var.vpn_instance_size
  key_name = var.ssh_key_pair
#   associate_elastic_ip_address = true
  subnet_id = aws_subnet.public_subnet[0].id
  vpc_security_group_ids = [aws_security_group.infra.id]
  depends_on = [
    aws_eip.vpn
  ]
  tags = {
    "Name"= "${var.environment}-${var.name}-vpn"
    "Environment"= "${var.environment}"
  }
}
resource "aws_instance" "master" {
  count = var.master_count
  ami           = "ami-055d15d9cfddf7bd3"
  instance_type = var.master_size
  key_name = var.ssh_key_pair
  associate_public_ip_address = false
  subnet_id = aws_subnet.private_subnet[0].id
  vpc_security_group_ids = [aws_security_group.infra.id]
  tags = {
    "Name"= "${var.environment}-${var.name}-master"
    "Environment"= "${var.environment}"
  }
}