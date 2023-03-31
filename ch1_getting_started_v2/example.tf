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

# S3 Bucket の作成
resource "aws_s3_bucket" "my_website" {
  ## バケット名はAWSのグローバルで一意になるように設定する
  bucket = "s3-website-test-hatakeyama-20230325"
}

# 静的Webサイトホスティング
resource "aws_s3_bucket_website_configuration" "my_website" {
  bucket = aws_s3_bucket.my_website.id

  ## Webサイト設定
  index_document {
    suffix = "index.html"
  }
}

# オブジェクトの読み出しをバケットポリシーで制御する
resource "aws_s3_bucket_policy" "bucket-policy" {
  bucket = aws_s3_bucket_website_configuration.my_website.id
  policy = file("policy.json")
}

# S3 static website endpoint
output "my_website_endpoint" {
  value = aws_s3_bucket_website_configuration.my_website.website_endpoint
}