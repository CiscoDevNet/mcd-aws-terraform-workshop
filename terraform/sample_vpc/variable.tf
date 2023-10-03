variable prefix {
  description = "Name tag prefix that's added to all the resource names."
}

variable aws_ssh_key_pair_id {
  description = "SSH Keypair ID used for App EC2 Instances."
}

# variable "aws_availability_zones" {
#     description = "Availability zones in which to create the Service VPC Transit Gateway instances."
#     type        = list(string)
#     default     = []
# }

variable "mcd_controller_aws_account_number" {
  description = "Multicloud Defense Controller's account number."
}

