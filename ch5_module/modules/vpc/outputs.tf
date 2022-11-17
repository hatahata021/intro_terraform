# 別のリソースから参照したい属性はoutputしておく
output "vpc_id" {
    value = aws_vpc.main.id
}

output "subnet_a_id" {
  value = aws_subnet.public_a.id
}

output "subnet_c_id" {
  value = aws_subnet.public_c.id
}