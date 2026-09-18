terraform {
  backend "s3" {
    bucket     = "<AWS_ACCOUNT_ID>-tfstates-<AWS_REGION>"
    key        = "dev/iam/terraform.tfstate"
    kms_key_id = "alias/tfstates"
    encrypt    = true
    dynamodb_table = "tfstates-locking"
    region         = "<AWS_REGION>"
  }
}
