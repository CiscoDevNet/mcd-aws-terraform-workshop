# __generated__ by Terraform
# Please review these resources and move them into your main configuration files.

# __generated__ by Terraform from "ciscomcd-gateway-role"
resource "aws_iam_role" "iam_role" {
  assume_role_policy    = "{\"Statement\":[{\"Action\":\"sts:AssumeRole\",\"Effect\":\"Allow\",\"Principal\":{\"Service\":\"ec2.amazonaws.com\"}}],\"Version\":\"2012-10-17\"}"
  description           = null
  force_detach_policies = false
  managed_policy_arns   = []
  max_session_duration  = 3600
  name                  = "ciscomcd-gateway-role"
  name_prefix           = null
  path                  = "/"
  permissions_boundary  = null
  tags                  = {}
  tags_all              = {}
  inline_policy {
    name   = "mcd-gateway-policy"
    policy = "{\"Version\":\"2012-10-17\",\"Statement\":[{\"Action\":[\"s3:PutObject\",\"s3:ListBucket\"],\"Effect\":\"Allow\",\"Resource\":\"arn:aws:s3:::*/*\"},{\"Action\":\"kms:Decrypt\",\"Effect\":\"Allow\",\"Resource\":\"*\"},{\"Action\":\"secretsmanager:GetSecretValue\",\"Effect\":\"Allow\",\"Resource\":\"*\"}]}"
  }
}
