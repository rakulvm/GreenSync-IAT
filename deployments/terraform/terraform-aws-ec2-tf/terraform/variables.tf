variable "aws_instance" {
  type    = string
  default = "t2.micro"
}

variable "aws_ami" {
  type    = string
  default = "ami-0884d2865dbe9de4b"
}

variable "availability_zone" {
  type    = string
  default = "us-east-2a"
}

variable "availability_zone_2" {
  type    = string
  default = "us-east-2b"
}

variable "aws_key" {
  type    = string
  default = "django-e2e"
  }

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "subnet_cidr" {
  type    = string
  default = "10.0.1.0/24"
}

variable "public2_subnet_cidr" {
  type    = string
  default = "10.0.2.0/24"
}

variable "aws_route_table" {
  type    = string
  default = "0.0.0.0/0"
}

variable "ingress_ipv4" {
  type    = string
  default = "0.0.0.0/0"
}

variable "egress_ipv4" {
  type    = string
  default = "0.0.0.0/0"
}

variable "certificate_arn" {
  type = string
  default = "arn:aws:acm:us-east-2:309555896103:certificate/d724aa1e-40b8-4da2-b4ab-3126dea8aba8"
}