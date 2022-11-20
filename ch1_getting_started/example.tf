terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "ap-northeast-1"
}

# S3 Bucket for static website hosting
resource "aws_s3_bucket" "my_website" {
  ## バケット名はAWSのグローバルで一意になるように設定する
  bucket = "s3-website-test-c4r8pckxd"
  ## 外部からのアクセスを許可するため、ACLは public-read にする
  acl = "public-read"
  ## オブジェクトの読み出しをバケットポリシーで制御する
  policy = file("policy.json")

  ## Webサイト設定
  website {
    index_document = "index.html"
  }
}

# S3 static website endpoint
output "my_website_endpoint" {
  value = aws_s3_bucket.my_website.website_endpoint
}