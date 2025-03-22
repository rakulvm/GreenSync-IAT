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
  default = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC+DXluLv9YdjWzNm/trRTJH0nsjKoSvvOyQdJ1d3GIZ4QPS5KT8b9j2I78Jv0ZjxHxaU5WiZ4iyVUVVhecCrJs0FgfwxyR7k4D2hlfBV7rp5vNOGVjWpJlWh/YRqnKu3jvlXvA6COiWzhid6AVjnDNwHqzE2wH/Gmf/pFTY6c4VYPqxJSFz9ocFMh/OPKMLTgipcZXuxT7AfgITqLcykcyHRk+dH8yGyjp0pPhmF2MSyTPoAim00l83Xtx6vi+Fw8sVGOeqEIN6WMSu08TxiqzlXksj14zNM3irSgCzyG0anX/GIhxzBLzdSxn7wZx781PCEJieAevz1DfSLSQljVihW/AwKZgVGU5yHrukLm9VFxbgf9xgsAyfU32SHUMPB3PoFNUeSCotkgF/uwqwwAU9vxkCURwUUaisIM8jAv8Jkw6QUYgFc7YnJnttAcIPAW65+IJQjzlD0yIHGka0Qk3PgTelnPu/aunl5+oUoFbhBIInKnftDsTCMkyGiBHQLM= rakul@Rakul"
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