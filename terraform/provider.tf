terraform {
  required_providers {
    # --- Step 2: Onboard with Cisco Multicloud Defense ---
    # ciscomcd = {
    #   source = "ciscodevnet/ciscomcd"
    #   # version = "0.2.4"
    # }
  }

  backend "s3" {
    # Change this to a unique bucket name
    bucket = "mcd-terraform-workshop-email-example-com"
    key    = "terraform/terraform.tfstate"
    region = "us-east-1"
  }
}

# --- Step 2: Onboard with Cisco Multicloud Defense ---
# provider "ciscomcd" {
#   api_key_file = file("cisco_mcd/mcd_api_key.json")
# }
