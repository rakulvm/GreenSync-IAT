terraform {
  required_providers {
    godaddy = {
      source  = "n3integration/godaddy"
      version = "~> 1.9.1"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "godaddy" {
  key    = var.godaddy_api_key
  secret = var.godaddy_api_secret
}

provider "aws" {
  region = "us-east-2"
} 