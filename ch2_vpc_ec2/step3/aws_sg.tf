## Security Group
resource "aws_security_group" "allow_ssh" {
  name        = "${var.project_code}-allow-ssh"
  description = "Allow SSH inbound traffic"
  vpc_id      = aws_vpc.main.id

  ## cidr_blocks を自分の環境の外部IPに変更する
  ## curl https://httpbin.org/ip
  ## で確認する。
  ingress {
    description = "SSH from VPC"
    from_port   = 22
    to_port     = 22
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
    Name = "${var.project_code}-allow-ssh"
  }
}
