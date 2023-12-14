module "sample_vpc" {
  source                = "./sample_vpc"
  prefix                = "spoke1"
  aws_ssh_key_pair_id   = var.aws_ssh_key_pair_id
  aws_availability_zone = var.aws_availability_zone

  ###  Step 5: Enable VPC Traffic Visibility  ###
  mcd_dns_query_log_config_id = module.cisco_mcd.mcd_dns_query_log_config_id
  mcd_s3_bucket               = module.cisco_mcd.mcd_s3_bucket

  ###  Step 7: Secure VPC  ###
  mcd_service_vpc_id     = module.cisco_mcd.mcd_service_vpc_id
  mcd_transit_gateway_id = module.cisco_mcd.mcd_transit_gateway_id
}

module "cisco_mcd" {
  source                            = "./cisco_mcd"
  mcd_deployment_name               = var.mcd_deployment_name
  mcd_controller_aws_account_number = var.mcd_controller_aws_account_number
  mcd_cloud_account_name            = var.mcd_cloud_account_name
  aws_ssh_key_pair_id               = var.aws_ssh_key_pair_id
  aws_availability_zone             = var.aws_availability_zone
}
