terraform {
  required_providers {
    ciscomcd = {
      source = "CiscoDevNet/ciscomcd"
    }
  }

  backend "s3" {
    bucket = "mcd-cdo-cisco-dstaudt-230925-102409"
    key    = "terraform/terraform.tfstate"
    region = "us-east-1"
  }
}

provider "aws" {
  region  = var.aws_region
  # profile = var.aws_credentials_profile
}

provider "ciscomcd" {
    api_key_file = file(var.mcd_api_key_file)
}
