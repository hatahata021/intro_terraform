# 別のリソースから参照したい属性はoutputしておく
output "public_ip" {
  value = aws_instance.main.public_ip
}