module "sample_vpc" {
  source                = "./sample_vpc1"
  prefix                = "spoke1"
  aws_ssh_key_pair_name = var.aws_ssh_key_pair_name
  aws_availability_zone1= var.aws_availability_zone1
  aws_availability_zone2 = var.aws_availability_zone2

  # ---  Step 4: Enable VPC Traffic Visibility  ---
  # mcd_dns_query_log_config_id       = module.cisco_mcd.mcd_dns_query_log_config_id
  # mcd_s3_bucket                     = module.cisco_mcd.mcd_s3_bucket
  # mcd_controller_aws_account_number = var.mcd_controller_aws_account_number

  # ---  Step 6: Secure Sample VPC  ---
  # mcd_service_vpc_id     = module.cisco_mcd.mcd_service_vpc_id
  # mcd_transit_gateway_id = module.cisco_mcd.mcd_transit_gateway_id
}

# --- Step 2: Onboard with Cisco Multicloud Defense ---
# module "cisco_mcd" {
#   source                            = "./cisco_mcd"
#   mcd_deployment_name               = var.mcd_deployment_name
#   mcd_controller_aws_account_number = var.mcd_controller_aws_account_number
#   mcd_cloud_account_name            = var.mcd_cloud_account_name
#   aws_ssh_key_pair_name             = var.aws_ssh_key_pair_name
#   aws_availability_zone1             = var.aws_availability_zone1
#   aws_availability_zone2             = var.aws_availability_zone2
# }
