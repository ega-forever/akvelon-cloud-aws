data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_vpc" "VPC" {
  cidr_block = var.VpcCIDR
  enable_dns_hostnames = true
  enable_dns_support = true
  tags = { "Stack" = var.GlobalTagValue }
}
resource "aws_internet_gateway" "InternetGateway"{
  # VPCGatewayAttachment created automatically when assigning the vpc_id
  vpc_id = aws_vpc.VPC.id
  tags = { "Stack" = var.GlobalTagValue }
}

resource "aws_subnet" "PublicSubnet1" {
  cidr_block = var.PublicSubnet1CIDR
  vpc_id = aws_vpc.VPC.id
  map_public_ip_on_launch = true
  availability_zone = data.aws_availability_zones.available.names[0]
  tags = { "Stack" = var.GlobalTagValue }
}

resource "aws_subnet" "PublicSubnet2" {
  cidr_block = var.PublicSubnet2CIDR
  vpc_id = aws_vpc.VPC.id
  map_public_ip_on_launch = true
  availability_zone = data.aws_availability_zones.available.names[1]
  tags = { "Stack" = var.GlobalTagValue }
}

resource "aws_subnet" "PrivateSubnet1" {
  cidr_block = var.PrivateSubnet1CIDR
  vpc_id = aws_vpc.VPC.id
  map_public_ip_on_launch = false
  availability_zone = data.aws_availability_zones.available.names[0]
  tags = { "Stack" = var.GlobalTagValue }
}

resource "aws_subnet" "PrivateSubnet2" {
  cidr_block = var.PrivateSubnet2CIDR
  vpc_id = aws_vpc.VPC.id
  map_public_ip_on_launch = false
  availability_zone = data.aws_availability_zones.available.names[1]
  tags = { "Stack" = var.GlobalTagValue }
}

resource "aws_eip" "NatGateway1EIP"{
  depends_on = [aws_internet_gateway.InternetGateway]
  # Domain: vpc
  vpc = true
  tags = { "Stack" = var.GlobalTagValue }
}

resource "aws_eip" "NatGateway2EIP"{
  depends_on = [aws_internet_gateway.InternetGateway]
  # Domain: vpc
  vpc = true
  tags = { "Stack" = var.GlobalTagValue }
}

resource "aws_nat_gateway" "NatGateway1" {
  allocation_id = aws_eip.NatGateway1EIP.id
  subnet_id = aws_subnet.PublicSubnet1.id
  tags = { "Stack" = var.GlobalTagValue }
}

resource "aws_nat_gateway" "NatGateway2" {
  allocation_id = aws_eip.NatGateway2EIP.id
  subnet_id = aws_subnet.PublicSubnet2.id
  tags = { "Stack" = var.GlobalTagValue }
}

resource "aws_route_table" "PublicRouteTable" {
  vpc_id = aws_vpc.VPC.id
  tags = { "Stack" = var.GlobalTagValue }
}

resource "aws_route" "DefaultPublicRoute" {
  depends_on = [aws_internet_gateway.InternetGateway]
  route_table_id = aws_route_table.PublicRouteTable.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.InternetGateway.id
}

resource "aws_route_table_association" "PublicSubnet1RouteTableAssociation" {
  route_table_id = aws_route_table.PublicRouteTable.id
  subnet_id = aws_subnet.PublicSubnet1.id
}

resource "aws_route_table_association" "PublicSubnet2RouteTableAssociation" {
  route_table_id = aws_route_table.PublicRouteTable.id
  subnet_id = aws_subnet.PublicSubnet2.id
}

resource "aws_route_table" "PrivateRouteTable1" {
  vpc_id = aws_vpc.VPC.id
  tags = { "Stack" = var.GlobalTagValue }
}

resource "aws_route" "DefaultPrivateRoute1" {
  route_table_id = aws_route_table.PrivateRouteTable1.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.NatGateway1.id
}

resource "aws_route_table_association" "PrivateSubnet1RouteTableAssociation" {
  route_table_id = aws_route_table.PrivateRouteTable1.id
  subnet_id = aws_subnet.PrivateSubnet1.id
}

resource "aws_route_table" "PrivateRouteTable2" {
  vpc_id = aws_vpc.VPC.id
  tags = { "Stack" = var.GlobalTagValue }
}

resource "aws_route" "DefaultPrivateRoute2" {
  route_table_id = aws_route_table.PrivateRouteTable2.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.NatGateway2.id
}

resource "aws_route_table_association" "PrivateSubnet2RouteTableAssociation" {
  route_table_id = aws_route_table.PrivateRouteTable2.id
  subnet_id = aws_subnet.PrivateSubnet2.id
}
