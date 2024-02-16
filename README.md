# mcd-aws-terraform-workshop
Sample Terraform scripts and GitHub Actions config demonstrating Cisco Multicloud Defense onboarding/discovery/deployment/protection.

## Getting Started

### AWS - Setup GitHub OIDC Auth

### AWS - Create S3 Bucket for Terraform State

1. Navigate/login to the AWS Secure Storage Service (S3)

1. Create a new bucket.

   Be sure to pick a name that is [unique across all of AWS](https://docs.aws.amazon.com/AmazonS3/latest/userguide/bucketnamingrules.html), e.g. based on your email: 
   
   ```
   mcd-aws-terraform-workshop-email.example.com
   ```

   Enable bucket versioning.

   You can leave other settings at their defaults.

### Fork the GitHub Project Repository

1. Open a new browser tab and navigate to: https://github.com/CiscoDevNet/mcd-aws-terraform-workshop

1. Make sure you are logged into GitHub.

1. In the upper-right, click on **Fork**.

   You can leave the defaults as-is.

1. Once the forked repository page appears, select the **Actions** tab.

    Go ahead and enable workflows.

### Create Actions Environment Secrets

1. In the forked GitHub repo, select **Settings / Secrets and variables / Actions**.

1. Under **Repository Secrets** create the following:

   * **ACTIONS_RUNNER_DEBUG**: `true`

   * **MCD_API_KEY**: Paste in the full JSON content of your Cisco Multicloud Defense API key file.

   * **AWS_OIDC_IDP_ROLE_ARN**: The ARN of the AWS OIDC IdP created above.

   * **AWS_S3_BUCKET_NAME**: The name of the Terraform backend S3 bucket created previously.


