## VPC settings
resource "aws_vpc" "main" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"

  tags = {
    Name = var.project_code
  }
}

## Internet Gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.project_code}-igw"
  }
}

## Subnet (ap-northeast-1a)
resource "aws_subnet" "public_a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.subnet.public_a.cidr
  availability_zone = var.subnet.public_a.az

  tags = {
    Name = "${var.project_code}-public-a"
  }
}

## Subnet (ap-northeast-1c)
resource "aws_subnet" "public_c" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.subnet.public_c.cidr
  availability_zone = var.subnet.public_c.az

  tags = {
    Name = "${var.project_code}-public-c"
  }
}

## Route table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "${var.project_code}-public"
  }
}

## Association for subnet_a
resource "aws_route_table_association" "public_a" {
  subnet_id      = aws_subnet.public_a.id
  route_table_id = aws_route_table.public.id
}

## ... subnet_c
resource "aws_route_table_association" "public_c" {
  subnet_id      = aws_subnet.public_c.id
  route_table_id = aws_route_table.public.id
}