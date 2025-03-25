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
  key    = "gHptDaEZnP48_6JjzMLRdG4ptJG7ddAqqhC"
  secret = "Qz3eevDBU2F4gMoqe9vtcV"
}

provider "aws" {
  region = "us-east-2"
} 