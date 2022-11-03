# What is this ?
ch2_vpc_ec2/step3の環境を、モジュール化してみる
まだまだ改良の余地あり、少しずつ改良していく

# moduleで作成したリソースのID参照方法
moduleを定義したtfファイルの中で、idをoutputで指定しておくと参照できる

（例）
moduleを定義したtfファイルでoutput属性を作成しておく
```
## Security Group
variable "sg_name" {}
variable "sg_discription" {}
variable "vpc_id" {}
variable "global_ip" {}

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

output "security_group_id" {
  value = aws_security_group.allow_http.id  
}
```
↓

moduleを参照する
```
module "sg_for_instance" {
    source = "./modules/sg"

    #name = "sg_for_instance"
    sg_name = "allow-http"
    sg_discription = "Allow http ingrass and egress all allow"
    vpc_id = mo
    #tags_name =  "${var.project_code}-allow-http"
    global_ip = var.global_ip
  
}
```

↓
moduleに参照しに行く
```
  vpc_security_group_ids      = [module.sg_for_instance.security_group_id]
```

## 注意事項
output属性はmoduleを定義しているtfファイルの中に書く必要がありそう