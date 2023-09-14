terraform {
  required_providers {
    ciscomcd = {
      source = "CiscoDevNet/ciscomcd"
    }
  }
}

provider "aws" {
  region  = var.aws_region
  profile = var.aws_credentials_profile
}

provider "ciscomcd" {
    api_key_file = file(var.mcd_api_key_file)
}
