terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "ap-northeast-1"
}

## VPC settings
resource "aws_vpc" "main" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "simple-ec2"
  }
}

## Internet Gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "simple-ec2-igw"
  }
}

## Subnet (ap-northeast-1a)
resource "aws_subnet" "public_a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "ap-northeast-1a"

  tags = {
    Name = "simple-ec2-public-a"
  }
}

## Subnet (ap-northeast-1a)
resource "aws_subnet" "public_c" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "ap-northeast-1c"

  tags = {
    Name = "simple-ec2-public-c"
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
    Name = "simple-ec2-public"
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

## Security Group
resource "aws_security_group" "allow_http" {
  name        = "simple-ec2-allow-http"
  description = "Allow HTTP inbound traffic"
  vpc_id      = aws_vpc.main.id

  ## cidr_blocks を自分の環境の外部IPに変更する
  ## curl http://checkip.amazonaws.com
  ## で確認する。
  ingress {
    description = "HTTP from My IP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.main.cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "simple-ec2-allow-http"
  }
}

### EC2 Instance
## Latest Amazon Linux 2 AMI
data "aws_ami" "amazon_linux_2" {
  most_recent = true

  owners = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
}

## EC2 Instance
resource "aws_instance" "main" {
  ami                         = data.aws_ami.amazon_linux_2.id
  associate_public_ip_address = true
  instance_type               = "t2.micro"
  key_name                    = "my_keypair"
  vpc_security_group_ids      = [aws_security_group.allow_http.id]
  subnet_id                   = aws_subnet.public_a.id
  user_data                   = file("userdata.sh")

  tags = {
    Name = "simple-ec2"
  }
}

output "ec2_public_ip" {
  value = aws_instance.main.public_ip
}