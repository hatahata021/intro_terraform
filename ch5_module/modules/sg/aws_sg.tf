## Security Group
variable "sg_name" {}
variable "sg_discription" {}
variable "vpc_id" {}
variable "global_ip" {}
variable "project_code" {}

resource "aws_security_group" "allow_http" {
  name        =  var.sg_name
  description = var.sg_discription
  vpc_id      = var.vpc_id

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

# 別のリソースから参照したい属性はoutputしておく
output "security_group_id" {
  value = aws_security_group.allow_http.id  
}