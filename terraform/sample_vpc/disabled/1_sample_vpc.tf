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
  tags = {
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

resource "aws_subnet" "sample_subnet" {
  availability_zone = var.aws_availability_zone
  vpc_id            = aws_vpc.sample_vpc.id
  cidr_block        = "10.0.0.0/16"
  tags = {
    Name = "${var.prefix}-subnet"
  }
}

resource "aws_route_table" "sample_route_table" {
  vpc_id = aws_vpc.sample_vpc.id
  tags = {
    Name = "${var.prefix}-rt"
  }
}

## Step 7 - Disable this version of the sample route (towards internet gateway)
resource "aws_route" "sample_internet_route" {
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.sample_internet_gateway.id
  route_table_id         = aws_route_table.sample_route_table.id
}

# ## Step 7 - Enable this version of the sample route (towards MCD transit gateway)
# resource "aws_route" "sample_internet_route" {
#   destination_cidr_block = "0.0.0.0/0"
#   transit_gateway_id     = var.mcd_transit_gateway_id
#   route_table_id         = aws_route_table.sample_route_table.id
#   depends_on = [
#     ciscomcd_spoke_vpc.mcd_spoke
#   ]
# }

resource "aws_route_table_association" "sample_subnet_route_table_association" {
  route_table_id = aws_route_table.sample_route_table.id
  subnet_id      = aws_subnet.sample_subnet.id
}

resource "aws_security_group" "sample_security_group" {
  name   = "${var.prefix}-security-group"
  vpc_id = aws_vpc.sample_vpc.id
  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    protocol    = "tcp"
    from_port   = 22
    to_port     = 22
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    protocol    = "tcp"
    from_port   = 8000
    to_port     = 8000
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    protocol    = "tcp"
    from_port   = 443
    to_port     = 443
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "${var.prefix}-security-group"
  }
}

resource "aws_iam_role" "spoke_iam_role" {
  name = "${var.prefix}-spoke-role"
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
  path = "/"
  inline_policy {
    name = "spoke-iam-policy"
    policy = jsonencode(
      {
        Version = "2012-10-17",
        Statement = [
          {
            Action   = "*"
            Resource = "*"
            Effect   = "Allow"
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

resource "aws_instance" "app_instance" {
  associate_public_ip_address = true
  availability_zone           = var.aws_availability_zone
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
  subnet_id                   = aws_subnet.sample_subnet.id
  vpc_security_group_ids      = [aws_security_group.sample_security_group.id]
  tags = {
    Name = "${var.prefix}-app"
    // Step ??? - Custom Security Policies
    Category = "prod"
  }
}

