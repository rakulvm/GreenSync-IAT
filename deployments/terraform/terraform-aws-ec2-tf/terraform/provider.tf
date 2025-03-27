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
  key    = "gHptDaEZnP48_3VUgwE2sKpbXAzcC7sEynk"
  secret = "8gTX8SN532ZRkL8tUbtHZJ"
}

provider "aws" {
  region = "us-east-2"
} 