variable "mcd_deployment_name" {
  description = "MCD cloud service instance (prod1 for main production)"
  default     = "prod1"
}

variable "mcd_controller_aws_account_number" {
  description = "Multicloud Defense AWS Controller's account number."
  default     = "878511901175" # AMER region
}

variable "mcd_cloud_account_name" {
  description = "Name used to represent the AWS Account in the MCD Dashboard."
}

variable "aws_availability_zone" {
  description = "AWS availability zone in which to create the Service VPC Transit Gateway instance."
  type        = string
}

variable "aws_ssh_key_pair_name" {
  description = "SSH Keypair ID used for App EC2 Instances."
}
