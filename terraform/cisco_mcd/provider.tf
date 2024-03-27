terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.42.0"
    }
    ciscomcd = {
      source  = "CiscoDevNet/ciscomcd"
      version = "0.2.5"
    }
  }
}
