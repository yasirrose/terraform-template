# iam
This Terraform configuration is to create global resources (not regional) for your AWS accounts.
The most basic one that you may create is the IAM role `cd-deploy` used by Screwdriver to create AWS resources.
# How to create your global resources
In this directory, we will use these placeholders:
| Placeholders           | Description                                         |
|------------------------|-----------------------------------------------------|
| `<DEV_ATHENZ_DOMAIN>`  | Your dev Athenz domain.                             |
| `<PROD_ATHENZ_DOMAIN>` | Your prod Athenz domain.                            |
| `<AWS_ACCOUNT_ID>`     | Your AWS account ID (eg: `111111111111`).           |
| `<AWS_REGION>`         | Your AWS region (eg: `us-east-1`).                  |
| `<ENVIRONMENT>`        | Your staging environment (eg: `dev`, `prod`, etc.). |
| `YOUR_TEAM`            | Your team (for email address).                      |
| `YOUR_ORG`             | Your GitHub organization name.                      |
| `YOUR_REPOSITORY`      | Your GitHub repository name.                        |
If you see these placeholders, you should replace them by your own values.
1. Make sure you have the `fed.admin.user` IAM role's AWS credentials for your AWS account (`dev` or `prod`).
2. Review the following files to **replace the placeholders** and **pin the latest module versions**:
   - `backend.tf`
   - `iam.tf`
   - `locals.tf`
   - `main.tf`
   - `variables.tf`
3. Apply the Terraform configuration by running this:
    ```bash
    terraform init
    terraform providers lock -platform=linux_amd64
    terraform apply
    ```
