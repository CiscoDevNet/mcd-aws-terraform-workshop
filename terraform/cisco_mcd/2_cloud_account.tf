# Give the role a few seconds to finalize in AWS
resource "time_sleep" "wait_for_controller_account" {
  create_duration = "15s"
  depends_on = [
    aws_iam_role.mcd_controller_role
  ]
}

resource "ciscomcd_cloud_account" "mcd_cloud_account" {
  name                     = var.mcd_cloud_account_name
  csp_type                 = "AWS"
  aws_credentials_type     = "AWS_IAM_ROLE"
  aws_iam_role             = aws_iam_role.mcd_controller_role.arn
  aws_account_number       = data.aws_caller_identity.current.account_id
  aws_iam_role_external_id = ciscomcd_external_id.mcd_external_id.external_id
  aws_inventory_iam_role   = aws_iam_role.mcd_inventory_role.arn
  inventory_monitoring {
    regions = [data.aws_region.current.name]
  }
  depends_on = [
    time_sleep.wait_for_controller_account
  ]
}