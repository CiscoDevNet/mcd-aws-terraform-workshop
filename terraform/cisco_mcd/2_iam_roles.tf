resource "aws_iam_role" "mcd_inventory_role" {
  name = "mcd-inventory-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Principal = {
          Service = "events.amazonaws.com"
        },
        Effect = "Allow"
      }
    ]
  })
}

data "aws_caller_identity" "current" {}

resource "aws_iam_role_policy" "mcd_inventory_policy" {
  name = "mcd-inventory-policy"
  role = aws_iam_role.mcd_inventory_role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "events:PutEvents",
        Effect = "Allow",
        Resource = [
          "arn:aws:events:*:${var.mcd_controller_aws_account_number}:event-bus/default"
        ]
      },
      {
        Action = "events:InvokeApiDestination",
        Effect = "Allow",
        Resource = [
          "arn:aws:events:*:${data.aws_caller_identity.current.account_id}:api-destination/*"
        ]
      }
    ]
  })
}

resource "aws_iam_role" "mcd_gateway_role" {
  name = "mcd-gateway-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Principal = {
          Service = "ec2.amazonaws.com"
        },
        Effect = "Allow"
      }
    ]
  })
}

resource "aws_iam_instance_profile" "mcd_gateway_instance_profile" {
  # Instance profile name must match the role name
  name = aws_iam_role.mcd_gateway_role.name
  role = aws_iam_role.mcd_gateway_role.name
}

resource "aws_iam_role_policy" "mcd_gateway_policy" {
  name = "mcd-gateway-policy"
  role = aws_iam_role.mcd_gateway_role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = [
          "s3:PutObject",
          "s3:ListBucket"
        ],
        Effect   = "Allow",
        Resource = "arn:aws:s3:::*/*"
      },
      {
        Action = [
          "kms:Decrypt"
        ],
        Effect   = "Allow",
        Resource = "*"
      },
      {
        Action = [
          "secretsmanager:GetSecretValue"
        ],
        Effect   = "Allow",
        Resource = "*"
      }
    ]
  })
}

resource "ciscomcd_external_id" "mcd_external_id" {
  name = "mcd_external_id"
}

resource "aws_iam_role" "mcd_controller_role" {
  name = "mcd-controller-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Principal = {
          AWS = [
            "arn:aws:iam::${var.mcd_controller_aws_account_number}:root"
          ]
        },
        Effect = "Allow",
        Condition = {
          StringEquals = {
            "sts:ExternalId" = ciscomcd_external_id.mcd_external_id.external_id
          }
        }
      }
    ]
  })
}

resource "aws_iam_role_policy" "mcd_controller_policy" {
  name = "mcd_controller_policy"
  role = aws_iam_role.mcd_controller_role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = [
          "acm:DescribeCertificate",
          "acm:ListCertificates",
          "apigateway:GET",
          "ec2:*",
          "elasticloadbalancing:*",
          "events:*",
          "globalaccelerator:*",
          "iam:ListPolicies",
          "iam:ListRoles",
          "iam:ListRoleTags",
          "logs:*",
          "route53resolver:*",
          "servicequotas:GetServiceQuota",
          "s3:ListAllMyBuckets",
          "s3:ListBucket"
        ],
        Effect   = "Allow",
        Resource = "*"
      },
      {
        Action = [
          "iam:GetRole",
          "iam:ListRolePolicies",
          "iam:GetRolePolicy"
        ],
        Effect = "Allow",
        Resource = [
          aws_iam_role.mcd_controller_role.arn,
          aws_iam_role.mcd_inventory_role.arn,
          aws_iam_role.mcd_gateway_role.arn,
          aws_iam_instance_profile.mcd_gateway_instance_profile.arn
        ]
      },
      {
        Action = [
          "iam:PassRole"
        ],
        Effect = "Allow",
        Resource = [
          aws_iam_role.mcd_gateway_role.arn,
          aws_iam_role.mcd_inventory_role.arn
        ]
      },
      {
        Action   = "iam:CreateServiceLinkedRole",
        Effect   = "Allow",
        Resource = "arn:aws:iam::*:role/aws-service-role/*"
      },
      {
        Action = [
          "secretsmanager:CreateSecret",
          "secretsmanager:UpdateSecret",
          "secretsmanager:DeleteSecret",
          "secretsmanager:GetSecretValue",
          "secretsmanager:PutSecretValue"
        ],
        Effect = "Allow",
        Resource = [
          "arn:aws:secretsmanager:*:*:secret:events!*"
        ]
      }
    ]
  })
  depends_on =  [
    aws_iam_role_policy.mcd_inventory_policy,
    aws_iam_role_policy.mcd_gateway_policy
  ]
}

# Give the policy a few seconds to replicate in AWS
resource "time_sleep" "wait_for_controller_policy" {
  create_duration = "30s"
  depends_on = [
    aws_iam_role_policy.mcd_controller_policy
  ]
}



