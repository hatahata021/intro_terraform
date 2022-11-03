variable "keypair" {}
variable "project_code" {}
variable "security_group_id" {}
variable "subnet_a_id" {}

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
  vpc_security_group_ids      = [var.security_group_id]
  subnet_id                   = var.subnet_a_id
  user_data                   = file("userdata.sh")

  tags = {
    Name = var.project_code
  }
}

# 別のリソースから参照したい属性はoutputしておく
output "public_ip" {
  value = aws_instance.main.public_ip
}