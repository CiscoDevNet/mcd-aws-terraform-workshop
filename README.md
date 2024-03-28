# mcd-aws-terraform-workshop

Sample Terraform scripts and GitHub Action demonstrating Cisco Multicloud Defense onboarding/discovery/deployment/protection in an infrastructure-as-code scenario.

Companion to Cisco Devnet learning lab: [Cisco Multicloud Defense - Terraform](https://devnetapps.cisco.com/learning/labs/mcd-terraform)

See:

[Cisco Multicloud Defense](https://www.cisco.com/site/us/en/products/security/multicloud-defense/index.html)

[CiscoDevNet/ciscomcd - Terraform provider](https://registry.terraform.io/providers/CiscoDevNet/ciscomcd/latest/docs)

## Getting Started

Detailed, step-by-step instructions can be found in the associated DevNet Learning Lab: [Cisco Multicloud Defense - Terraform](https://devnetapps.cisco.com/learning/labs/mcd-terraform)

At a high level:

1. Fork this repository on GitHub.

1. Enable GitHub Actions.

1. Create/download a Cisco Multicloud Defense API Key with admin/read-write role.

1. Configure AWS IAM with GitHub OIDC identity provider/role for the forked repo.

1. Create an AWS EC2 authentication key pair with name: `mcd-lab`

1. Create an AWS S3 bucket as storage for Terraform state.

1. Create GitHub action repo secrets:

   * **AWS_REGION:** `us-east-1`

   * **AWS_OIDC_IDP_ROLE_ARN**

   * **AWS_S3_BUCKET_NAME**

   * **MCD_API_KEY:** JSON contents of MCD API key file

   and repo variable:

   * **ACTIONS_RUNNER_DEBUG:** `true`

1. GitHub action basic functionality can be verified by running the `Terraform apply` action via a manual run (no resources should get created).  Commit-based dispatch can be enabled by uncommenting the `push:` section of `action.yaml`.

1. Once verified, create a new branch (`Baseline_Cleanup`) before proceeding with the lab to create resources - manually running the GitHub action against this baseline branch will destroy all resources created by the lab.

The learning lab then proceeds to create a sample VPC and MCD service VPC and enable various security policies in 7 steps.  Each step involves moving a Terraform config file from a module's `disabled/` folder into the parent module folder (based on the leading number of the file name), and/or uncommenting/commenting out lines in specific Terraform files (marked with inline comments, e.g. `Step 2: Onboard with Cisco Multicloud Defense`).



