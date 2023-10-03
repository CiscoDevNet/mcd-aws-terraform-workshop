# import {
#     to = valtix_service_vpc.mcd_service_vpc
#     id = "2"
# }

# import {
#     to = aws_vpc.aws_service_vpc
#     id = "vpc-02e9497826fcd46fe"
# }

# import {
#     to = aws_ec2_transit_gateway.mcd_transit_gateway
#     id = "tgw-0642dfc29ac2ca43f"
# }

# import {
#     to = ciscomcd_gateway.mcd_internet_gateway
#     id = "egress-us-east-1-gw-01"
# }

# import {
#     to = aws_security_group.datapath_security_group
#     id = "sg-0c32479905c0a3f17"
# }

# import {
#     to = aws_security_group.mgmt_security_group
#     id = "sg-0c35d171b388b2d17"
# }

# import {
#     to = valtix_policy_rule_set.policy-ruleset
#     id = 2
# }

# import {
#     to = valtix_policy_rules.egress_ew_policy_rules
#     id = "3"
# }

##################

# data "valtix_address_object" "any_ag" {
#   name = "any"
# }

# data "valtix_address_object" "any_private_rfc1918_ag" {
#   name = "any-private-rfc1918"
# }

# data "valtix_address_object" "internet_ag" {
#   name = "internet"
# }

# resource "valtix_policy_rules" "egress-ew-policy-rules" {
#     rule_set_id = valtix_policy_rule_set.egress_ew_policy.id
#     rule {
#         name        = "private-to-private"
#         action      = "Allow Log"
#         state       = "ENABLED"
#         service     = valtix_service_object.tcp_all_ports.id
#         source      = data.valtix_address_object.any_private_rfc1918_ag.id
#         destination = data.valtix_address_object.any_private_rfc1918_ag.id
#         type        = "Forwarding"
#     }
#     rule {
#         name        = "private-to-internet"
#         action      = "Allow Log"
#         state       = "ENABLED"
#         service     = valtix_service_object.tcp_all_ports.id
#         source      = data.valtix_address_object.any_private_rfc1918_ag.id
#         destination = data.valtix_address_object.internet_ag.id
#         type        = "Forwarding"
#     }
#     rule {
#         name        = "any-to-any"
#         action      = "Deny Log"
#         state       = "ENABLED"
#         service     = valtix_service_object.tcp_all_ports.id
#         source      = data.valtix_address_object.any_ag.id
#         destination = data.valtix_address_object.any_ag.id
#         type        = "Forwarding"
#     }
# }

# resource "aws_ec2_transit_gateway" "mcd-tg1" {
#   description = "MCD Service VPC Transit Gateway"
# }

# resource "valtix_service_vpc" "mcd_service_vpc" {
#   name               = "mcd-service-vpc"
#   csp_account_name   = var.valtix_aws_cloud_account_name
#   region             = var.region
#   cidr               = "10.100.0.0/16"
#   management_cidr    = "10.10.1.0/24"
#   availability_zones = [var.zone]
#   transit_gateway_id = aws_ec2_transit_gateway.mcd-tg1.id
#   depends_on         = [module.aws_setup, aws_ec2_transit_gateway.mcd-tg1]
# }

# resource "valtix_gateway" "aws-hub-gw1" {
#   name                      = "aws-hub-gw"
#   description               = "AWS Hub Gateway 1"
#   csp_account_name          = var.valtix_aws_cloud_account_name
#   instance_type             = "AWS_M5_LARGE"
#   gateway_image             = "23.06-08"
#   mode                      = "HUB"
#   security_type             = "EGRESS"
#   gateway_state             = "ACTIVE"
#   policy_rule_set_id        = valtix_policy_rule_set.egress_rule_set.rule_set_id
#   ssh_key_pair              = var.aws_ssh_key_pair
#   aws_iam_role_firewall     = module.aws_setup.valtix_firewall_role.name
#   region                    = var.region
#   vpc_id                    = valtix_service_vpc.service_vpc.id
#   aws_gateway_lb            = true
#   depends_on                = [valtix_service_vpc.service_vpc, valtix_policy_rule_set.egress_rule_set]
# }

