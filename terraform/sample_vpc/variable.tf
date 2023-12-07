variable "prefix" {
  description = "Prefix to be added to all VPC resource names."
}

variable "aws_ssh_key_pair_id" {
  description = "SSH Keypair ID used for the sample PVC's EC2 instances."
}

variable "aws_availability_zone" {
  description = "Availability zone in which to create the service VPC Transit Gateway instance."
  type        = string
  default     = ""
}

variable "mcd_controller_aws_account_number" {
  description = "Multicloud Defense Controller's account number."
  default     = ""
}


