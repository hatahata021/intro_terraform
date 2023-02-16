variable "resource_name" {
  type = string
}

variable "admin_username" {}
variable "admin_password" {}

variable "main_locaiton" {
  type    = string
  default = "japaneast"
}

# SGで穴あけをするクライアントIPを変数として定義しておく
# tfvarsファイルを用意しなければ、plan,apply時に入力する
variable "client_ip" {}

#  （httpプロバイダー使用時）data source で、自分のIPアドレスをHTTPレスポンスとして受け取る 
# data "http" "client_ip" {
#   url = "https://ifconfig.co/ip"
# }

# （httpプロバイダー使用時）空の変数を定義しておく
# variable "client_ip" {
#   default = null
# }

#  （httpプロバイダー使用時）HTTPレスポンスボディから改行文字を削除し、var.client_ipが空の時にdata sourceのレスポンスを変数として定義する
# locals {
#   current-ip = chomp(data.http.client_ip.body)
#   client_ip  = (var.client_ip == null) ? "${local.current-ip}/32" : var.client_ip
# }
# 参考：https://dev.classmethod.jp/articles/reference-my-pubic-ip-in-terraform/
