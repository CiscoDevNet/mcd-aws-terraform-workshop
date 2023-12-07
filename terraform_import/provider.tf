terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.29.0"
    }
    ciscomcd = {
      source = "CiscoDevNet/ciscomcd"
      version = "0.2.4"
    }
  }
}

provider "ciscomcd" {
    api_key_file = file(var.mcd_api_key_file)
}
