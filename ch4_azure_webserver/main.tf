terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}
}

# 指定したURLからのレスポンスをData Sourceで取得できるプロバイダー
provider "http" {
  # version = "~> 3.0"
}