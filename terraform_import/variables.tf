# Configuration variables

variable "aws_region" {
  description = "AWS Region, required only when being run as root module"
  default     = ""
}

variable "aws_credentials_profile" {
  description = "AWS Credentials Profile Name, required only when run as root module"
  default     = ""
}

variable "mcd_api_key_file" {
  description = "Valtix API Key json file name downloaded from the Valtix Dashboard, required only when being run as root module"
  default     = ""
}

# variable "aws_ssh_key_pair" {
#     description = "AWS EC2 network key pair to use when defining/accessing resources"
#     type = string
#     default = ""
# }

variable "deployment_name" {
  description = "Valtix Controller deployment name (ask Valtix)"
  default     = "prod1"
}

# variable "prefix" {
#   description = "Prefix for resources created in this template"
#   default     = "valtix"
# }

variable "controller_aws_account_number" {
  description = "Valtix provided aws account number (ask Valtix)"
}

# variable "object_duration" {
#   description = "Duration (in days) after which the objects in the s3 bucket are deleted"
#   default     = 1
# }

# variable "create_cloud_trail" {
#   description = "Create a multi region CloudTrail and store the events in the s3_bucket. If you already have a CloudTrail, then provide this value as false"
#   default     = true
#   type        = bool
# }

variable "mcd_cloud_account_name" {
  description = "Name used to represent this AWS Account on the Valtix Dashboard, if this is empty the AWS account is not added to the Valtix Controller"
  default     = ""
}

# variable "inventory_regions" {
#   description = "Regions that Valtix Controller can monitor and update the inventory for dynamic security policies: us-east-1, us-east-2"
#   type        = list(string)
#   default     = []
# }

# variable "zone" {
#     description = "Availability zone to create the Service VPC Transit Gateway"
#     type        = string
#     default     = ""
# }

# Dynamic variables

# variable "vpc_selected" {
#     default = null
# }

# variable "s3_bucket" {
#   description = "S3 Bucket to store CloudTrail, Route53 Query Logs and VPC Flow Logs"
#   default = null
# }

variable "app_vpc_id" { }

variable "mcd_tenant_name" {
    description = "MCD account tenant name."
    default = ""
}