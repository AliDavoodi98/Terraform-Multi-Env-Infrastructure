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
  availability_zone = "us-east-1"

  tags = {
    Name = "Public Subnet ${count.index+1}"
  }
}

resource "aws_subnet" "private_subnets" {
  vpc_id = aws_vpc.main_vpc.id
  count = length(var.private_subnet_cidrs)
  cidr_block = element(var.private_subnet_cidrs, count.index)
  availability_zone = "us-east-2"

  tags = {
    Name = "Private Subnet ${count.index+1}"
  }
}

resource "aws_internet_gateway" "main_igw" {
  vpc_id = aws_vpc.main_vpc.id
}

resource "aws_route_table" "main_public_rt" {
  vpc_id = aws_vpc.main_vpc.id
}

resource "aws_route" "internet_route" {
  route_table_id = aws_route_table.main_public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.main_igw.id
}

resource "aws_route_table_association" "main_public_rt_assoc" {
  subnet_id = aws_subnet.public_subnets.id
  route_table_id = aws_route_table.main_public_rt.id
}
