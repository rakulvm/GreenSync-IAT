# Basically we are creating a terraform IaC to create an Ec2 instance to deploy our django application where we need these basics resources in place:

# instance, key pair, security group, vpc -> where our subnet resides -> where our ec2 instance resides, internet gateway for allowing ansible to install dependencies by accessing the internet

resource "aws_key_pair" "django-deployer" {
  key_name   = "django-depl"
  public_key = var.aws_key
}

resource "aws_vpc" "main" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"

  tags = {
    Name = "main"
  }
}

resource "aws_subnet" "public" {
  vpc_id = aws_vpc.main.id
  cidr_block = var.subnet_cidr
  map_public_ip_on_launch = true
  availability_zone = var.availability_zone

  tags = {
    Name = "Public-Subnet"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "main-gateway"
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = var.aws_route_table
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "Public-Route-Table"
  }
}

resource "aws_route_table_association" "public_association" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public_rt.id
}


resource "aws_security_group" "django-sg" {
  name        = "django-sg"
  description = "Security group for django e2e project"
  vpc_id      = aws_vpc.main.id
  tags = {
    Name = "example"
  }
}

resource "aws_vpc_security_group_ingress_rule" "django-sg" {
  security_group_id = aws_security_group.django-sg.id
  cidr_ipv4   = var.ingress_ipv4
  from_port   = 80
  ip_protocol = "tcp"
  to_port     = 80
}

resource "aws_vpc_security_group_ingress_rule" "django-sg-ssh" {
  security_group_id = aws_security_group.django-sg.id
  cidr_ipv4   = var.ingress_ipv4
  from_port   = 22
  ip_protocol = "tcp"
  to_port     = 22
}

resource "aws_vpc_security_group_egress_rule" "django-sg-egress" {
  security_group_id = aws_security_group.django-sg.id
  cidr_ipv4   = var.egress_ipv4
  ip_protocol = "-1"
}

resource "aws_instance" "django_e2e" {
  ami = var.aws_ami
  instance_type     = var.aws_instance
  availability_zone = var.availability_zone
  key_name        = aws_key_pair.django-deployer.key_name
  subnet_id       = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.django-sg.id]

  tags = {
    Name = "Django-EC2"
  }

  provisioner "file" {
    source      = "installer.sh"
    destination = "/tmp/installer.sh"

  }

  provisioner "remote-exec" {
    inline = [
      "sudo chmod +x /tmp/installer.sh",
      "sh /tmp/installer.sh"
    ]

  }
 
  depends_on = [aws_security_group.django-sg]

  connection {
    type        = "ssh"
    host        = self.public_ip
    user        = "ubuntu"
    private_key = file("django-depl")
  }
}

