resource aws_route_table "vpc_route_table" {
  vpc_id = var.app_vpc_id
  route {
    cidr_block = "0.0.0.0/0"
    transit_gateway_id             = "tgw-0f792fbb145a3cca4"
    # gateway_id = "igw-0250a49151cf8ddc8"
  }
}

resource aws_route_table "spoke1-z1-apps_route_table" {
  vpc_id = var.app_vpc_id
  route {
    cidr_block = "0.0.0.0/0"
    transit_gateway_id             = "tgw-0f792fbb145a3cca4"
    # gateway_id = "igw-0250a49151cf8ddc8"
  }
  tags = {
    Name = "spoke1-z1-apps"
  }
}

resource aws_route_table "spoke1-z2-apps_route_table" {
  vpc_id = var.app_vpc_id
  route {
    cidr_block = "0.0.0.0/0"
    transit_gateway_id             = "tgw-0f792fbb145a3cca4"
    # gateway_id = "igw-0250a49151cf8ddc8"
  }
  tags = {
    Name = "spoke1-z2-apps"
  }
}
