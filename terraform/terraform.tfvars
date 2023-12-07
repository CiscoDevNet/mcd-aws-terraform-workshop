# MCD instance - prod1 for main production
# mcd_deployment_name = "prod1"
# MCD account tenant name
mcd_tenant_name = "CDO_cisco-dstaudt"
# MCD API key file path/name
mcd_api_key_file = "mcd_api_key.json"
# MCD Controller's AWS account number
mcd_controller_aws_account_number = "878511901175"
# MCD AWS cloud account name
mcd_cloud_account_name = "AWS_Test_Acct"
# MCD cross-account IAM role external Id
# mcd_cross_account_external_id = "osikeqshlakavrzygqfnnugbpwdbjhlykqjrvgakupsvkbyrfgyluydkxcuvimtk" 

# AWS account credentials and details
aws_region = "us-east-1"
aws_availability_zone = "us-east-1a"
# aws_ssh_key_pair_id = "key-011ddf763065c9601"
aws_ssh_key_pair_id = "key-02420d03f30a68340"

# Limit MCD inventory discovery access to this list of AWS regions 
mcd_inventory_regions = ["us-east-1"]
# S3 storage bucket where AWS DNS/flow logs will be delivered - must be unique across all of AWS!
# mcd_s3_bucket = "mcd-terraform-workshop"

# Prefix to use when creating AWS resource names
# aws_prefix = "mcd"
# Application VPC Id to monitor/protect
# app_vpc_id = "vpc-0039e7860b30d67af"

# # S3 log storage file retention time, # days
# object_duration = 1
# # Create a CloudTrail for logging?  Requires s3_bucket has been provided.
# create_cloud_trail = true

