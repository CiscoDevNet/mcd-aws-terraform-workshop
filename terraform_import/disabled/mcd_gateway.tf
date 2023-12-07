# import {
#     to = ciscomcd_gateway.mcd_gateway
#     id = "testGateway"
# }

resource "ciscomcd_gateway" "testGateway" {
	name = "testGateway"
	csp_account_name = "AWS_Test_Acct"
	instance_type = "AWS_M5_LARGE"
	mode = "HUB"
	gateway_state = "ACTIVE"
	policy_rule_set_id = 2
	min_instances = 1
	max_instances = 3
	health_check_port = 65534
	region = "us-east-1"
	vpc_id = 19
	aws_iam_role_firewall = "arn:aws:iam::257344898502:role/mcd-gateway-role"
	gateway_image = "23.08-09"
	ssh_key_pair = "mcd_lab"
	security_type = "EGRESS"
	aws_gateway_lb = true
	settings {
		name = "controller.gateway.assign_public_ip"
		value = "true"
	}
	settings {
		name = "gateway.aws.ebs.encryption.key.default"
		value = ""
	}
	settings {
		name = "gateway.snat_mode"
		value = "0"
	}
}