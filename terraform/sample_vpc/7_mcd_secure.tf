
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
