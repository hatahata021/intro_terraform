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
  key_name                    = "my_keypair"
  vpc_security_group_ids      = [aws_security_group.allow_http.id]
  subnet_id                   = aws_subnet.public_a.id
  user_data                   = file("userdata.sh")

  tags = {
    Name = var.project_code
  }
}