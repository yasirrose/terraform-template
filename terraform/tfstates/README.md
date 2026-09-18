# tfstates
This Terraform configuration is to bootstrap Terraform to allow Terraform to store safely and securely its state files
in S3.
# Bootstrap Terraform in a region (only need for the first time)
In this directory, we will use these placeholders:
| Placeholders       | Description                                         |
|--------------------|-----------------------------------------------------|
| `<AWS_ACCOUNT_ID>` | Your AWS account ID (eg: `111111111111`).           |
| `<AWS_REGION>`     | Your AWS region (eg: `us-east-1`).                  |
| `<ENVIRONMENT>`    | Your staging environment (eg: `dev`, `prod`, etc.). |
| `YOUR_TEAM`        | Your team (for email address).                      |
| `YOUR_ORG`         | Your GitHub organization name.                      |
| `YOUR_REPOSITORY`  | Your GitHub repository name.                        |
If you see these placeholders, you should replace them by your own values.
## Sanity checks before you start to bootstrap a region
1. **Make sure you don't have any `.terraform` directory.** If yes, remove it or rename it to `.terraform.bak`
2. **Make sure you don't have any `terraform.tfstate` file in the current directory.** If yes, remove it or rename it to
   `terraform.tfstate.bak`.
3. **Make sure you have the `fed.admin.user` IAM role's AWS credentials for the right account.** Most users will do this with `awsfed2`.
4. If this is the first time using this stack, **pin the latest module version** in the `main.tf` file.
## Let's start the bootstrap process
1. In the environment you are working in, rename `backend.tf` to `backend.tf.bak` so TF won't try to use the `s3` remote backend to store its state file.
2. Edit the `main.tf` file and replace the placeholders.
3. Edit the `variables.tf` file and replace the placeholders. 
4. Create the resources to bootstrap Terraform for the region:
    ```bash
    awsfed2 # log in, and choose the account you are configuring
    terraform init
    terraform providers lock -platform=linux_amd64
    terraform apply
    ```
    :information_source: If you encounter this error with the S3 bucket logging, don't worry:
    ```
    Error: creating S3 Bucket (992382847923-tfstates-us-east-1) Logging: operation error S3: PutBucketLogging, https response error StatusCode: 400, RequestID: ..., HostID: ..., api error InvalidTargetBucketForLogging: The target bucket for logging does not exist
    ```
    It means that Gacco didn't create the bucket `<AWS_ACCOUNT_ID>-bucket-logs-<AWS_REGION>` in this region yet. You can
    continue with the next step.
    Now that the S3 bucket and the DynamoDB are created, you can add the Terraform `s3` remote backend configuration.
5. Rename `backend.tf.bak` to `backend.tf`.
6. In the `backend.tf` file, edit the contents by replacing the placeholders.
    For example, if your environment is `dev-us-east-1`, you will edit the file as such with YOUR `account id` and `region`:
    ```hcl
    terraform {
      backend "s3" {
        bucket     = "111111111111-tfstates-us-east-1"
        key        = "dev/tfstates/terraform.tfstate"
        kms_key_id = "alias/tfstates"
        encrypt    = true
        dynamodb_table = "tfstates-locking"
        region         = "us-east-1"
      }
    }
    ```
7. Reconfigure your Terraform backend configuration with the `s3` remote backend by running this:
    ```bash
    terraform init -migrate-state
    ```
    It will prompt you if you want to copy your `local` Terraform state file to the new `s3` remote backend.
    Enter `yes`.
8. Go to http://yo/aws and check that the bucket `<AWS_ACCOUNT_ID>-tfstates-<AWS_REGION>` now contains the
   Terraform state file `<ENVIRONMENT>/tfstates/terraform.tfstate`.
   You can also get this information from `aws s3 ls` on the command line, ex. `aws s3 ls 458952069854-tfstates-us-east-1/sports/nonprod/tfstates/`.
9. Apply the Terraform configuration just to make sure everything works by running this:
    ```bash
    terraform apply
    ```
    Normally, you should see now that the Terraform application starts and ends with acquiring and releasing the lock to
    access to the `s3` remote state file.
    ```bash
    $ terraform apply
    Acquiring state lock. This may take a few moments...
    ...
    Releasing state lock. This may take a few moments...
    ```
    :information_source: If you're still facing the error with the S3 bucket logging before (`PutBucketLogging`), wait
    for Gacco to create the bucket `<AWS_ACCOUNT_ID>-bucket-logs-<AWS_REGION>`. It can take maybe 1 or 2h. Once the
    bucket is there, run the `terraform apply` above again.
10. Update `terraform/iam/common/main.tf` with contact info and the correct repo for your team. You can now commit your changes to Git.
Note: You will see a new file `.terraform.lock.hcl`. It is recommended to commit it to Git to freeze the provider &
dependencies versions.
Congratulations! Your region is ready to be used with Terraform! You're almost done - now just add Screwdriver access (README in root directory).
# Official documentation on Terraform S3 remote backend
https://www.terraform.io/language/settings/backends/s3
