resource "aws_internet_gateway" "ig" {
  vpc_id = "${aws_vpc.k8s_vpc.id}"
  tags = {
    Name        = "${var.environment}-${var.name}-igw"
    Environment = "${var.environment}"
  }
}
/* Elastic IP for NAT */
resource "aws_eip" "nat_eip" {
  vpc        = true
  depends_on = [aws_internet_gateway.ig]
  tags = {
    Name        = "${var.environment}-${var.name}-nat"
    Environment = "${var.environment}"
  }
}
resource "aws_eip" "vpn" {
  vpc = true
  depends_on = [aws_internet_gateway.ig]
}
resource "aws_eip_association" "vpn" {
  instance_id = aws_instance.vpn.id
  allocation_id = aws_eip.vpn.id
}
/* NAT */
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = element(aws_subnet.public_subnet.*.id, 0)
  depends_on    = [aws_internet_gateway.ig]
  tags = {
    Name        = "${var.environment}-${var.name}-nat"
    Environment = "${var.environment}"
  }
}
/* Public subnet */
resource "aws_subnet" "public_subnet" {
  count                   = length(var.k8s_public_subnets_cidr)
  vpc_id                  = aws_vpc.k8s_vpc.id
  cidr_block              = var.k8s_public_subnets_cidr[count.index]
  availability_zone       = var.availability_zone[count.index]
  map_public_ip_on_launch = true
  tags = {
    Name        = "${var.environment}-${var.name}-${element(var.availability_zone, count.index)}-public-subnet"
    Environment = "${var.environment}"
  }
}
/* Private subnet */
resource "aws_subnet" "private_subnet" {
  count                   = length(var.k8s_private_subnets_cidr)
  vpc_id                  = aws_vpc.k8s_vpc.id
  cidr_block              = var.k8s_private_subnets_cidr[count.index]
  availability_zone       = var.availability_zone[count.index]
  map_public_ip_on_launch = false
  tags = {
    Name        = "${var.environment}-${var.name}-${element(var.availability_zone, count.index)}-private-subnet"
    Environment = "${var.environment}"
  }
}
/* Routing table for private subnet */
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.k8s_vpc.id
}
/* Routing table for public subnet */
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.k8s_vpc.id
  route  {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ig.id
  }
}
resource "aws_route" "public_internet_gateway" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.ig.id
}
resource "aws_route" "private_nat_gateway" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat.id
}
/* Route table associations */
resource "aws_route_table_association" "public" {
  count          = length(var.k8s_public_subnets_cidr)
  subnet_id      = aws_subnet.public_subnet[count.index].id
  route_table_id = aws_route_table.public.id
}
resource "aws_route_table_association" "private" {
  count          = length(var.k8s_private_subnets_cidr)
  subnet_id      = aws_subnet.private_subnet[count.index].id
  route_table_id = aws_route_table.private.id
}
/*==== VPC's Default Security Group ======*/
resource "aws_security_group" "infra" {
  name        = "${var.environment}-${var.name}-sg"
  description = "Default security group to allow inbound/outbound from the VPC"
  vpc_id      = aws_vpc.k8s_vpc.id
  depends_on  = [aws_vpc.k8s_vpc]
  ingress {
    from_port = "0"
    to_port   = "0"
    protocol  = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    self      = true
  }
  
  egress {
    from_port = "0"
    to_port   = "0"
    protocol  = "-1"
    self      = true
    cidr_blocks = ["0.0.0.0/0"]

  }
  tags = {
    Environment = "${var.environment}"
  }
}