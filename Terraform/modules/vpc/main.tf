resource "aws_vpc" "main_vpc" {
  cidr_block = "10.0.0.0/16"
  
  tags = {
    Name = "Project's Main VPC"
  }
}

resource "aws_subnet" "public_subnets" {
  vpc_id = aws_vpc.main_vpc.id
  count = length(var.public_subnet_cidrs)
  cidr_block = element(var.public_subnet_cidrs, count.index)
  availability_zone = "us-east-1a"

  tags = {
    Name = "Public Subnet ${count.index+1}"
  }
}

resource "aws_subnet" "private_subnets" {
  vpc_id = aws_vpc.main_vpc.id
  count = length(var.private_subnet_cidrs)
  cidr_block = element(var.private_subnet_cidrs, count.index)
  availability_zone = "us-east-1b"

  tags = {
    Name = "Private Subnet ${count.index+1}"
  }
}

resource "aws_eip" "nat_eip" {
  vpc = true
}

resource "aws_nat_gateway" "main_nat_gw" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id = aws_subnet.public_subnets[1].id
}

resource "aws_internet_gateway" "main_igw" {
  vpc_id = aws_vpc.main_vpc.id
}

resource "aws_route_table" "main_public_route_table" {
  vpc_id = aws_vpc.main_vpc.id

  tags = {
    Name = "main_public_route_table"
  }
}

resource "aws_route_table" "main_private_route_table" {
  vpc_id = aws_vpc.main_vpc.id

  tags = {
    Name = "main_private_route_table"
  }
}

resource "aws_route" "public_internet_route" {
  route_table_id = aws_route_table.main_public_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.main_igw.id
}

resource "aws_route" "private_nat_route" {
  route_table_id = aws_route_table.main_private_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.main_nat_gw.id
}

resource "aws_route_table_association" "main_public_rt_assoc" {
  count = length(aws_subnet.public_subnets)
  subnet_id = aws_subnet.public_subnets[count.index].id
  route_table_id = aws_route_table.main_public_route_table.id
}

resource "aws_route_table_association" "main_private_rt_assoc" {
  count = length(aws_subnet.private_subnets)
  subnet_id = aws_subnet.private_subnets[count.index].id
  route_table_id = aws_route_table.main_private_route_table.id 
}