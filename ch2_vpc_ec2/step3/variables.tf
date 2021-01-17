## プロジェクト名を決めておく
variable "project_code" {
  type = string

  default = "simple-ec2"
}

## VPC CIDR
variable "vpc_cidr" {
  description = "VPC CIDR"
  type        = string

  default = "10.0.0.0/16"
}

## サブネット設定
variable "subnet" {
  description = "Subnet settings"
  type        = map(map(string))

  default = {
    public_a = {
      az   = "ap-northeast-1a"
      cidr = "10.0.1.0/24"
    }
    public_c = {
      az   = "ap-northeast-1c"
      cidr = "10.0.2.0/24"
    }
  }
}

## EC2に関連づけるキーペア名
variable "keypair" {
  description = "Key pair name"
  type        = string

  default = "my_keypair"
}

## 接続元IP
## 作業環境の外部IPを tfvars ファイルで指定する
variable "global_ip" {
  description = "My grobal IP (CIDR expression)"
  type        = string
}   