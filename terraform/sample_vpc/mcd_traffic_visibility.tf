variable "mcd_dns_query_log_config_id" {
  description = "AWS Query Log Configuration ID"
  default = ""
}

variable "mcd_s3_bucket" {
  description = "S3 Bucket to store CloudTrail, Route53 Query Logs and VPC Flow Logs"
  default = ""
}

resource "aws_route53_resolver_query_log_config_association" "mcd_query_log_association" {
  resource_id                  = aws_vpc.sample_vpc.id
  resolver_query_log_config_id = var.mcd_dns_query_log_config_id
}

resource "aws_flow_log" "app_vpc_flow_log" {
  vpc_id               = aws_vpc.sample_vpc.id
  traffic_type         = "ALL"
  log_destination_type = "s3"
  log_destination      = var.mcd_s3_bucket.arn
  log_format           = "$${account-id} $${action} $${az-id} $${bytes} $${dstaddr} $${dstport} $${end} $${flow-direction} $${instance-id} $${interface-id} $${log-status} $${packets} $${pkt-dst-aws-service} $${pkt-src-aws-service} $${pkt-dstaddr} $${pkt-srcaddr} $${protocol} $${region} $${srcaddr} $${srcport} $${start} $${sublocation-id} $${sublocation-type} $${subnet-id} $${tcp-flags} $${traffic-path} $${type} $${version} $${vpc-id}"
  tags = {
    Name = "${var.prefix}-mcd-flow-log"
  }
}

# resource "ciscomcd_spoke_vpc" "ciscomcd_spoke" {
#   service_vpc_id = ciscomcd_service_vpc.service_vpc.id
#   spoke_vpc_id   = "vpc-12345678912345678"
# }