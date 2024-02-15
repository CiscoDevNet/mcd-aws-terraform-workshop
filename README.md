# mcd-aws-terraform-workshop
Sample Terraform scripts and GitHub Actions config demonstrating Cisco Multicloud Defense onboarding/discovery/deployment/protection.

## Getting Started

### Fork the Project Repository

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
