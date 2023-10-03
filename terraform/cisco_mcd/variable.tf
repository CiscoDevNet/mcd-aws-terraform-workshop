variable "mcd_deployment_name" {
  description = "MCD instance (prod1 for main production)"
  default="prod1"
}

variable "mcd_controller_aws_account_number" {
  description = "Multicloud Defense Controller's account number."
  default     = "878511901175" # AMER region
}

variable "mcd_cloud_account_name" {
  description = "Name used to represent the AWS Account in the MCD Dashboard."
  default     = ""
}

variable "aws_availability_zones" {
    description = "Availability zones in which to create the Service VPC Transit Gateway instances."
    type        = list(string)
    default     = []
}

variable aws_ssh_key_pair_id {
  description = "SSH Keypair ID used for App EC2 Instances."
  default = ""
}