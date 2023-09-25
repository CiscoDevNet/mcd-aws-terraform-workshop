data "aws_iam_role" "ciscomcd-controller-role" {
    name = "ciscomcd-controller-role"
}

data "aws_iam_role" "ciscomcd-inventory-role" {
  name = "ciscomcd-inventory-role"
}

data "aws_caller_identity" "current" { }

data "ciscomcd_cloud_account" "mcd_cloud_account" {
  name = var.mcd_cloud_account_name
}

# resource "ciscomcd_cloud_account" "mcd_cloud_account" {
#   name                     = var.mcd_cloud_account_name
#   csp_type                 = "AWS"
#   aws_credentials_type     = "AWS_IAM_ROLE"
#   aws_iam_role             = data.aws_iam_role.ciscomcd-controller-role.arn
#   aws_account_number       = data.aws_caller_identity.current.account_id
#   aws_iam_role_external_id = var.mcd_cross_account_external_id
#   aws_inventory_iam_role   = data.aws_iam_role.ciscomcd-inventory-role.arn
#   inventory_monitoring {
#     regions = var.mcd_inventory_regions
#     refresh_interval = 60
#   }
# }
