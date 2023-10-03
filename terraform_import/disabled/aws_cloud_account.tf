# import {
#     to = ciscomcd_cloud_account.mcd_cloud_account
#     id = "AWS_Test_Acct"
# }

# import {
#     to = aws_iam_role.ciscomcd-gateway-role
#     id = "ciscomcd-gateway-role"
# }

import {
    to = aws_s3_bucket.mcd_s3_bucket
    id = "ciscomcd-cdo-cisco-dstaudt-230914-042538"
}