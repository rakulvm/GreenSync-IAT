# Basically we are creating a terraform IaC to create an Ec2 instance to deploy our django application where we need these basics resources in place:

# instance, key pair, security group, vpc -> where our subnet resides -> where our ec2 instance resides, internet gateway for allowing ansible to install dependencies by accessing the internet


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
    Name = "django-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "django-sg-jenkins" {
  security_group_id = aws_security_group.django-sg.id
  cidr_ipv4   = var.ingress_ipv4
  from_port   = 8080
  ip_protocol = "tcp"
  to_port     = 8080
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

resource "aws_s3_bucket" "lb_logs" {
  bucket = "django-log-bucket"

    tags = {
      Name        = "Django log bucket"
      Environment = "production"
    }
}

resource "godaddy_domain_record" "jenkins" {
  depends_on = [ aws_lb.django_e2e_alb ]

  domain = "e2e-app.xyz"
  record {
    name = "jenkins"
    type = "CNAME"
    data = aws_lb.django_e2e_alb.dns_name
    ttl  = 300
  }
}

resource "aws_lb_listener" "django_redirect" {
  load_balancer_arn = aws_lb.django_e2e_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_lb_listener" "django_listen" {
  load_balancer_arn = aws_lb.django_e2e_alb.arn
  port              = "443"
  protocol          = "HTTPS"
  certificate_arn   = var.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.django_e2e_tg.arn
  }
}

resource "aws_lb" "django_e2e_alb" {
  name               = "django-e2e-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.django-sg.id]
  subnet_id          = aws_subnet.public.id


  access_logs {
    bucket  = aws_s3_bucket.lb_logs.id
    prefix  = "django-e2e-alb"
    enabled = true
  }

  tags = {
    Environment = "production"
  }
}

resource "aws_lb_target_group" "django_e2e_tg" {
  name     = "django-e2e-tg"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id

   health_check {
    path                = "/"
    protocol            = "HTTP"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 30
  }
}

resource "aws_lb_target_group_attachment" "django_tg_attach" {
  target_group_arn = aws_lb_target_group.django_e2e_tg.arn
  target_id        = aws_instance.django_e2e.id
  port             = 8080
}


resource "aws_instance" "django_e2e" {
  ami = var.aws_ami
  instance_type     = var.aws_instance
  availability_zone = var.availability_zone
  key_name        = var.aws_key
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
    private_key = file("django-e2e.pem")
  }
}

