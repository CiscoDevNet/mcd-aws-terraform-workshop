resource "aws_ec2_transit_gateway" "mcd_transit_gateway" {
  dns_support                 = "enable"
  transit_gateway_cidr_blocks = []
  vpn_ecmp_support            = "enable"
  tags = {
    Name        = "mcd-service-vpc-tgw"
    valtix_acct = var.mcd_tenant_name
  }
}

data "ciscomcd_policy_rule_set" "ciscomcd-sample-egress-policy-ruleset" {
    name = "ciscomcd-sample-egress-policy-ruleset"
}

resource "ciscomcd_service_vpc" "service_vpc" {
  name               = "mcd-service-vpc"
  csp_account_name   = var.mcd_cloud_account_name
  region             = var.aws_region
  cidr               = "10.100.0.0/16"
  availability_zones = var.aws_availability_zones
  transit_gateway_id = aws_ec2_transit_gateway.mcd_transit_gateway.id
  depends_on         = [ciscomcd_cloud_account.mcd_cloud_account, aws_ec2_transit_gateway.mcd_transit_gateway]
}

data "aws_iam_role" "ciscomcd-gateway-role" {
    name = "ciscomcd-gateway-role"
}

data "aws_key_pair" "ssh_key_pair" {
    key_pair_id = var.aws_ssh_key_pair_id
}

resource "ciscomcd_gateway" "mcd_internet_gateway" {
  name                      = "egress-${var.aws_region}-gw-01"
  csp_account_name          = ciscomcd_cloud_account.mcd_cloud_account.name
  instance_type             = "AWS_M5_LARGE"
  gateway_image             = "23.04-15"
  mode                      = "HUB"
  security_type             = "EGRESS"
  gateway_state             = "ACTIVE"
  policy_rule_set_id        = data.ciscomcd_policy_rule_set.ciscomcd-sample-egress-policy-ruleset.id
  ssh_key_pair              = data.aws_key_pair.ssh_key_pair.key_name
  aws_iam_role_firewall     = data.aws_iam_role.ciscomcd-gateway-role.arn
  region                    = var.aws_region
  vpc_id                    = "${ciscomcd_service_vpc.service_vpc.id}"
  aws_gateway_lb            = true
  depends_on                = [ciscomcd_service_vpc.service_vpc, data.ciscomcd_policy_rule_set.ciscomcd-sample-egress-policy-ruleset]
}

