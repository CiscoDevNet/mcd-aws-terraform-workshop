# Configuration variables

variable "mcd_deployment_name" {
  description = "MCD instance (prod1 for main production)"
  default     = "prod1"
}

variable "mcd_tenant_name" {
    description = "MCD account tenant name."
    default = ""
}

variable "mcd_api_key_file" {
  description = "MCD API Key json file name downloaded from the MCD Dashboard, required only when being run as root module"
  default     = ""
}

variable "mcd_controller_account_number" {
  description = "Multicloud Defense Controller's Account Number"
}


variable "mcd_cross_account_external_id" {
    description = "MCD cross-account IAM role external Id"
    default = ""
}

variable "aws_credentials_profile" {
  description = "AWS Credentials Profile Name, required only when run as root module"
  default     = ""
}

variable "aws_region" {
  description = "AWS Region, required only when being run as root module"
  default     = ""
}

variable "aws_availability_zone" {
    description = "Availability zone in which to create the Service VPC Transit Gateway instance."
    type        = string
    default     = ""
}

variable "aws_ssh_key_pair_id" {
    description = "Id of the AWS EC2 network key pair to use when defining/accessing gatways resources."
    default = ""
}

variable "mcd_cloud_account_name" {
  description = "Name used to represent the AWS Account in the MCD Dashboard."
  default     = ""
}

variable "app_vpc_id" {
    description = "Target AWS VPC to monitor/protect"
    type = string
    default = ""
}

variable "aws_prefix" {
  description = "Prefix for resources created in this template"
  default     = "ciscomcd"
}

variable "mcd_s3_bucket_name" {
  description = "S3 Bucket to store CloudTrail, Route53 Query Logs and VPC Flow Logs"
  default = null
}

variable "object_duration" {
  description = "Duration (in days) after which the objects in the s3 bucket are deleted"
  default     = 1
}

variable "create_cloud_trail" {
  description = "Create a multi region CloudTrail and store the events in the s3_bucket. If you already have a CloudTrail, then provide this value as false"
  default     = true
  type        = bool
}

variable "mcd_inventory_regions" {
  description = "Limit MCD inventory discovery access to this list of AWS regions" 
  type        = list(string)
  default     = []
}
