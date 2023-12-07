terraform {
  required_providers {
    time = {
      source = "hashicorp/time"
      version = "0.10.0"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "5.29.0"
    }
    ciscomcd = {
      source = "CiscoDevNet/ciscomcd"
      version = "0.2.4"
    }
  }

  backend "s3" {
    bucket = "mcd-terraform-workshop-20231206"
    key    = "terraform/terraform.tfstate"
    region = "us-east-1"
  }
}

provider "ciscomcd" {
    api_key_file = file("./cisco_mcd/mcd_api_key.json")
}
