variable "employee_number" {
  type = string
}

variable "main_locaiton" {
  type    = string
  default = "japaneast"
}

# data source で、自分のIPアドレスをHTTPレスポンスとして受け取る 
data "http" "client_ip" {
  url = "https://ifconfig.co/ip"
}

# 空の変数を定義しておく
variable "client_ip" {
  default = null
}

# HTTPレスポンスボディから改行文字を削除し、var.client_ipが空の時にdata sourceのレスポンスを変数として定義する
locals {
  current-ip = chomp(data.http.client_ip.body)
  client_ip  = (var.client_ip == null) ? "${local.current-ip}/32" : var.client_ip
}
# 参考：https://dev.classmethod.jp/articles/reference-my-pubic-ip-in-terraform/
