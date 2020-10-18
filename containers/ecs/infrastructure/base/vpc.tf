resource "aws_vpc" "default" {
  cidr_block = var.vpc_cidr_block
  enable_dns_hostnames = true
  enable_dns_support = true
  assign_generated_ipv6_cidr_block = true
}

# If `aws_default_security_group` is not defined, it would be created implicitly with access `0.0.0.0/0`
resource "aws_default_security_group" "default" {
  vpc_id = aws_vpc.default.id
  ingress {
    from_port = 0
    protocol = "-1"
    to_port = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 0
    protocol = "-1"
    to_port = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
  depends_on = [aws_vpc.default]
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_internet_gateway" "default" {
  vpc_id = aws_vpc.default.id
}

resource "aws_eip" "nat_gateway" {
  vpc = true
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_nat_gateway" "default" {
  allocation_id = aws_eip.nat_gateway.id
  subnet_id = aws_subnet.public.id
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_subnet" "public" {
  vpc_id = aws_vpc.default.id
  availability_zone = var.vpc_public_subnet_az
  cidr_block = var.vpc_public_subnet_cidr
  map_public_ip_on_launch = true
}

resource "aws_subnet" "public2" {
  vpc_id = aws_vpc.default.id
  availability_zone = var.vpc_public_subnet2_az
  cidr_block = var.vpc_public_subnet2_cidr
  map_public_ip_on_launch = true
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.default.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.default.id
  }
}

resource "aws_route_table_association" "public" {
  subnet_id = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public2" {
  subnet_id = aws_subnet.public2.id
  route_table_id = aws_route_table.public.id
}

resource "aws_network_acl" "public" {
  vpc_id = aws_vpc.default.id
  subnet_ids = [aws_subnet.public.id]

  egress {
    rule_no = 100
    action = "allow"
    cidr_block = "0.0.0.0/0"
    from_port = 0
    to_port = 0
    protocol = "-1"
  }

  ingress {
    rule_no = 100
    action = "allow"
    cidr_block = "0.0.0.0/0"
    from_port = 0
    to_port = 0
    protocol = "-1"
  }
}

resource "aws_subnet" "private" {
  vpc_id = aws_vpc.default.id
  availability_zone = var.vpc_private_subnet_az
  cidr_block = var.vpc_private_subnet_cidr
}

resource "aws_subnet" "private2" {
  vpc_id = aws_vpc.default.id
  availability_zone = var.vpc_private_subnet2_az
  cidr_block = var.vpc_private_subnet2_cidr
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.default.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.default.id
  }
}

resource "aws_route_table_association" "private" {
  subnet_id = aws_subnet.private.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private2" {
  subnet_id = aws_subnet.private2.id
  route_table_id = aws_route_table.private.id
}

resource "aws_network_acl" "private" {
  vpc_id = aws_vpc.default.id
  subnet_ids = [aws_subnet.private.id]

  egress {
    rule_no = 100
    action = "allow"
    cidr_block = "0.0.0.0/0"
    from_port = 0
    to_port = 0
    protocol = "-1"
  }

  ingress {
    rule_no = 100
    action = "allow"
    cidr_block = "0.0.0.0/0"
    from_port = 0
    to_port = 0
    protocol = "-1"
  }
}
