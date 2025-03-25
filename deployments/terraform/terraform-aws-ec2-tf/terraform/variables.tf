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
  default = "arn:aws:acm:us-east-2:309555896103:certificate/3a9524c0-e169-4dc6-8357-7b4c274a42ba"
}

variable "godaddy_api_key" {
  type = string
  default = "gHptDaEZnP48_6JjzMLRdG4ptJG7ddAqqhC"
}

variable "godaddy_api_secret" {
  type = string
  default = "Qz3eevDBU2F4gMoqe9vtcV"
}