provider "aws" {
  region = var.aws_region
}
locals {
  common_tags = {
    "corp:Environment" = local.environment
    "corp:Stack"       = "common"
    "corp:Owner"       = "YOUR_TEAM@yahooinc.com"
    ManagedBy          = "https://git.ouryahoo.com/YOUR_ORG/YOUR_REPOSITORY/tree/main/terraform/iam/environments/${local.environment}"
  }
}
