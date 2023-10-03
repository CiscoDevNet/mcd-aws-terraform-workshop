data "aws_key_pair" "aws_ssh_key_pair" {
    key_pair_id = var.aws_ssh_key_pair_id
}

data "aws_ami" "ubuntu2204" {
  most_recent = true
  owners      = ["099720109477"] # Canonical
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_vpc" "sample_vpc" {
  cidr_block = "10.0.0.0/16"
  tags       = {
    Name = "${var.prefix}-vpc"
  }
}

resource "aws_internet_gateway" "sample_internet_gateway" {
  tags = { 
    Name = "${var.prefix}-igw"
  }
}

resource "aws_internet_gateway_attachment" "sample_igw_attachment" {
  internet_gateway_id = aws_internet_gateway.sample_internet_gateway.id
  vpc_id              = aws_vpc.sample_vpc.id
}

resource "aws_subnet" "sample_apps_subnet1" {
  availability_zone = "us-east-1a"
  vpc_id            = aws_vpc.sample_vpc.id
  cidr_block        = "10.0.0.0/17"
  tags              = {
    Name = "${var.prefix}-z1-subnet"
  }
}

resource "aws_subnet" "sample_apps_subnet2" {
  availability_zone = "us-east-1b"
  vpc_id            = aws_vpc.sample_vpc.id
  cidr_block        = "10.0.128.0/17"
  tags = {
    Name = "${var.prefix}-z2-subnet"
  }
}

resource "aws_route_table" "route_table_apps1" {
  vpc_id = aws_vpc.sample_vpc.id
  tags   = {
    Name = "${var.prefix}-z1-rt"
  }
}

resource "aws_route_table" "route_table_apps2" {
  vpc_id = aws_vpc.sample_vpc.id
  tags   = {
    Name = "${var.prefix}-z2-rt"
  }
}

resource "aws_route" "internet_route_apps1" {
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.sample_internet_gateway.id
  route_table_id         = aws_route_table.route_table_apps1.id
}

resource "aws_route" "internet_route_apps2" {
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.sample_internet_gateway.id
  route_table_id         = aws_route_table.route_table_apps2.id
}

resource "aws_route_table_association" "apps_subnet_route_table_association1" {
  route_table_id = aws_route_table.route_table_apps1.id
  subnet_id      = aws_subnet.sample_apps_subnet1.id
}

resource "aws_route_table_association" "apps_subnet_route_table_association2" {
  route_table_id = aws_route_table.route_table_apps2.id
  subnet_id      = aws_subnet.sample_apps_subnet2.id
}

resource "aws_security_group" "security_group_apps" {
  name        = "${var.prefix}-apps-sg"
  description = "Security group for the apps, used by applications."
  vpc_id      = aws_vpc.sample_vpc.id
  egress {
    protocol = "-1"
    from_port = 0
    to_port = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    protocol = "tcp"
    from_port = 22
    to_port = 22
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    protocol = "tcp"
    from_port = 80
    to_port = 80
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    protocol = "tcp"
    from_port = 8000
    to_port = 8000
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    protocol = "tcp"
    from_port = 443
    to_port = 443
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "${var.prefix}-apps"
  }
}

resource "aws_iam_role" "spoke_iam_role" {
  name               = "${var.prefix}-spoke-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = [
            "ec2.amazonaws.com"
          ]
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
  path               = "/"
  inline_policy {
    name = "spoke-iam-policy"
    policy = jsonencode(
      {
        Version = "2012-10-17",
        Statement = [
          {
            Action =  "*"
            Resource = "*"
            Effect = "Allow"
          }
        ]
      }
    )
  }
}

resource "aws_iam_instance_profile" "spoke_instance_profile" {
  name = "${var.prefix}-instance-profile"
  path = "/"
  role = aws_iam_role.spoke_iam_role.name
}

resource "aws_instance" "app_instance1" {
  associate_public_ip_address = true
  availability_zone           = "us-east-1a"
  ami                         = data.aws_ami.ubuntu2204.id
  iam_instance_profile        = aws_iam_instance_profile.spoke_instance_profile.name
  instance_type               = "t2.nano"
  key_name                    = data.aws_key_pair.aws_ssh_key_pair.key_name
  user_data                   = <<-EOT
                                #!/bin/bash
                                apt-get update
                                apt-get upgrade -y
                                apt-get install -y apache2
                                apt-get install -y wget
                                cat <<EOF > /var/www/html/index.html
                                <html><body><h1>Hello World</h1>
                                <p>Welcome to App Instance 1</p>
                                </body></html>
                                EOT
  subnet_id                   = aws_subnet.sample_apps_subnet1.id
  vpc_security_group_ids      = [aws_security_group.security_group_apps.id]
  tags                        = {
    Name = "${var.prefix}-z1-app"
  }
}

resource "aws_instance" "app_instance2" {
  associate_public_ip_address = true
  availability_zone           = "us-east-1b"
  ami                         = data.aws_ami.ubuntu2204.id
  iam_instance_profile        = aws_iam_instance_profile.spoke_instance_profile.name
  instance_type               = "t2.nano"
  key_name                    = data.aws_key_pair.aws_ssh_key_pair.key_name
  user_data                   = <<-EOT
                                #! /bin/bash
                                apt-get update
                                apt-get upgrade -y
                                apt-get install -y apache2
                                apt-get install -y wget
                                cat <<EOF > /var/www/html/index.html
                                <html><body><h1>Hello World</h1>
                                <p>Welcome to App Instance 2</p>
                                </body></html>
                                EOT
  subnet_id                   = aws_subnet.sample_apps_subnet2.id
  vpc_security_group_ids      = [aws_security_group.security_group_apps.id]
  tags                        = {
    Name = "${var.prefix}-z2-app"
  }
}

