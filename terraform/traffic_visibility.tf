data "aws_vpc" "app_vpc" {
  id = var.app_vpc_id
}

data "aws_s3_bucket" "mcd_s3_bucket" {
  bucket = var.mcd_s3_bucket_name
}

resource "aws_route53_resolver_query_log_config" "mcd_query_log_config" {
  name            = "valtix-route53-query-logs-${var.app_vpc_id}"
  destination_arn = data.aws_s3_bucket.mcd_s3_bucket.arn
  tags = {
    Name        = "valtix-route53-query-logs-${var.app_vpc_id}"
    valtix_acct = var.mcd_tenant_name
  }
  # depends_on = [data.ciscomcd_cloud_account.mcd_cloud_account]
}

resource "aws_route53_resolver_query_log_config_association" "mcd_query_log_association" {
  resource_id = var.app_vpc_id
  resolver_query_log_config_id = aws_route53_resolver_query_log_config.mcd_query_log_config.id
}

resource "aws_flow_log" "app_vpc_flow_log" {
  vpc_id               = var.app_vpc_id
  traffic_type         = "ALL"
  log_destination_type = "s3"
  log_destination      = data.aws_s3_bucket.mcd_s3_bucket.arn
  log_format           = "$${account-id} $${action} $${az-id} $${bytes} $${dstaddr} $${dstport} $${end} $${flow-direction} $${instance-id} $${interface-id} $${log-status} $${packets} $${pkt-dst-aws-service} $${pkt-src-aws-service} $${pkt-dstaddr} $${pkt-srcaddr} $${protocol} $${region} $${srcaddr} $${srcport} $${start} $${sublocation-id} $${sublocation-type} $${subnet-id} $${tcp-flags} $${traffic-path} $${type} $${version} $${vpc-id}"
  max_aggregation_interval = 60
  tags = {
    Name = "valtix-vpc-flow-logs-${var.app_vpc_id}"
    valtix_acct = var.mcd_tenant_name
  }
}