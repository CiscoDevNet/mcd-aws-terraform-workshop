variable "aws_availability_zone" {
  description = "AWS availability zone in which to create VPCs."
  type        = string
}

variable "aws_ssh_key_pair_name" {
  description = "AWS SSH key pair name - used for managing/connecting to instances."
  type        = string
}

# variable "mcd_api_key_file" {
#   description = "MCD API key JSON file path downloaded from the MCD Dashboard."
#   type        = string
# }

variable "mcd_inventory_regions" {
  description = "Limit MCD inventory discovery access to this list of AWS regions"
  type        = list(string)
}

variable "mcd_deployment_name" {
  description = "MCD deployment/instance name"
  type        = string
  default     = "prod1" #Production environment
}

variable "mcd_controller_aws_account_number" {
  description = "Multicloud Defense Controller's account number."
  type        = string
  default     = "878511901175" #AMER region
}

variable "mcd_cloud_account_name" {
  description = "Name used to represent the onboarded AWS Account in the MCD Dashboard."
}
