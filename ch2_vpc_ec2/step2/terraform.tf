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

#########################################
### Input Variables
#########################################

## プロジェクト名を決めておく
variable "project_code" {
  type = string

  default = "simple-ec2"
}

## VPC CIDR
variable "vpc_cidr" {
  description = "VPC CIDR"
  type        = string

  default = "10.0.0.0/16"
}

## サブネット設定
variable "subnet" {
  description = "Subnet settings"
  type        = map(map(string))

  default = {
    public_a = {
      az   = "ap-northeast-1a"
      cidr = "10.0.1.0/24"
    }
    public_c = {
      az   = "ap-northeast-1c"
      cidr = "10.0.2.0/24"
    }
  }
}

## EC2に関連づけるキーペア名
variable "keypair" {
  description = "Key pair name"
  type        = string

  default = "my_keypair"
}

## 接続元IP
## 作業環境の外部IPを tfvars ファイルで指定する
variable "global_ip" {
  description = "My grobal IP (CIDR expression)"
  type        = string
}


#########################################
### Resources
#########################################

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

## Security Group
resource "aws_security_group" "allow_http" {
  name        = "${var.project_code}-allow-http"
  description = "Allow HTTP inbound traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "HTTP from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.global_ip]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_code}-allow-http"
  }
}

### EC2 Instance
## Latest Amazon Linux 2 AMI
data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]

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
  key_name                    = var.keypair
  vpc_security_group_ids      = [aws_security_group.allow_http.id]
  subnet_id                   = aws_subnet.public_a.id
  user_data                   = file("userdata.sh")

  tags = {
    Name = var.project_code
  }
}

#########################################
### Output Variables
#########################################

output "ec2_public_ip" {
  value = aws_instance.main.public_ip
}