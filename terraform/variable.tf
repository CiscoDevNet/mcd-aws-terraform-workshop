# Configuration variables
variable "mcd_deployment_name" {
  description = "MCD instance (prod1 for main production)"
  default     = "prod1" # Production instance
}

variable "mcd_tenant_name" {
    description = "MCD account tenant name."
    default = ""
}

variable "mcd_api_key_file" {
  description = "MCD API Key json file path downloaded from the MCD Dashboard."
  default     = ""
}

variable "mcd_controller_aws_account_number" {
  description = "Multicloud Defense Controller's account number."
  default     = "878511901175" # AMER region
}

variable "mcd_cross_account_external_id" {
    description = "MCD cross-account IAM role external Id."
    default = ""
}

variable "aws_region" {
  description = "AWS Region."
}

variable "aws_availability_zone" {
    description = "Availability zone in which to create the Service VPC Transit Gateway instances."
    type        = string
    default     = ""
}

variable "aws_ssh_key_pair_id" {
    description = "ID of the AWS EC2 network key pair to use when defining/accessing gateways resources."
}

variable "mcd_cloud_account_name" {
  description = "Name used to represent the AWS Account in the MCD Dashboard."
  default     = ""
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
