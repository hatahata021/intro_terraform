
# 別のリソースから参照したい属性はoutputしておく
output "security_group_id" {
  value = aws_security_group.allow_http.id  
}