resource "aws_ec2_transit_gateway" "mcd_transit_gateway" {
  default_route_table_association = "disable"
  default_route_table_propagation = "disable"
  dns_support                     = "enable"
  transit_gateway_cidr_blocks     = []
  vpn_ecmp_support                = "enable"
  tags                            = {
    Name        = "mcd-service-vpc-tgw"
  }
  depends_on = [
    ciscomcd_cloud_account.mcd_cloud_account
  ]
}

resource "ciscomcd_service_vpc" "service_vpc" {
  name               = "mcd-service-vpc"
  csp_account_name   = ciscomcd_cloud_account.mcd_cloud_account.name

  availability_zones = [var.aws_availability_zone]
  cidr               = "10.100.0.0/16"
  region             = data.aws_region.current.name
  transit_gateway_id = aws_ec2_transit_gateway.mcd_transit_gateway.id
  depends_on = [
    aws_ec2_transit_gateway.mcd_transit_gateway
  ]
}

data "aws_key_pair" "aws_ssh_key_pair" {
    key_pair_id = var.aws_ssh_key_pair_id
}

resource "ciscomcd_policy_rule_set" "mcd_egress_rule_set" {
  name = "mcd-egress-policy-ruleset"
}

resource "ciscomcd_gateway" "mcd_gateway" {
  name                   = "mcd-egress-${data.aws_region.current.name}-gw-01"
  vpc_id                 = ciscomcd_service_vpc.service_vpc.id
	aws_iam_role_firewall  = aws_iam_role.mcd_gateway_role.name
	csp_account_name       = ciscomcd_cloud_account.mcd_cloud_account.name
	gateway_image          = "23.10-02" // Via MCD admin portal **Administration** / **System**
	instance_type          = "AWS_M5_LARGE"
	max_instances = 3
	min_instances = 1
	mode                   = "HUB"
	policy_rule_set_id     = ciscomcd_policy_rule_set.mcd_egress_rule_set.id
	region                 = data.aws_region.current.name
	security_type          = "EGRESS"
	ssh_key_pair           = data.aws_key_pair.aws_ssh_key_pair.key_name
  gateway_state          = "ACTIVE"
  wait_for_gateway_state = true
  depends_on = [
    ciscomcd_service_vpc.service_vpc,
    ciscomcd_policy_rule_set.mcd_egress_rule_set
  ]
}

output "mcd_transit_gateway_id" {
  value = aws_ec2_transit_gateway.mcd_transit_gateway.id
}

output "mcd_service_vpc_id" {
  value = ciscomcd_service_vpc.service_vpc.id
}