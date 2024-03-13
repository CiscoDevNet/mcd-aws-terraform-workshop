terraform {
  required_providers {
    ciscomcd = {
      source = "ciscodevnet/ciscomcd"
    }
  }

  backend "s3" {
    # Change this to a unique bucket name
    bucket = "PLACEHOLDER"
    key    = "terraform/terraform.tfstate"
    region = "us-east-1"
  }
}

provider "ciscomcd" {
  api_key_file = file("cisco_mcd/mcd_api_key.json")
}
