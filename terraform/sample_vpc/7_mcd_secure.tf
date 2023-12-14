
variable "mcd_service_vpc_id" {
  description = "MCD Service VPC ID"
}

variable "mcd_transit_gateway_id" {
  description = "MCD Service VPC Transit Gateway ID"
}

resource "ciscomcd_spoke_vpc" "mcd_spoke" {
  service_vpc_id = var.mcd_service_vpc_id
  spoke_vpc_id   = aws_vpc.sample_vpc.id
}

resource "aws_route" "sample_internet_route" {
  destination_cidr_block = "0.0.0.0/0"
  transit_gateway_id = var.mcd_transit_gateway_id
  route_table_id     = aws_route_table.sample_route_table.id
  depends_on = [
    ciscomcd_spoke_vpc.mcd_spoke
  ]
}