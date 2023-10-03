terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.19.0"
    }
    ciscomcd = {
      source = "CiscoDevNet/ciscomcd"
      version = "0.2.3"
    }
  }

  backend "s3" {
    bucket = "mcd-terraform-workshop-20231002"
    key    = "terraform/terraform.tfstate"
    region = "us-east-1"
  }
}

provider "ciscomcd" {
    api_key_file = file("./cisco_mcd/mcd_api_key.json")
}
