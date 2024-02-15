variable "prefix" {
  description = "Prefix to be added to all VPC resource names."
}

variable "aws_availability_zone" {
  description = "Availability zone in which to create the service VPC Transit Gateway instance."
  type        = string
}

variable "aws_ssh_key_pair_name" {
  description = "AWS SSH key pair Id - used for managing/connecting to instances."
}



