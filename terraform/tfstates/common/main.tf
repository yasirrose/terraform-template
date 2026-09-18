provider "aws" {
  region = var.aws_region
}
data "aws_caller_identity" "this" {}
module "tfstates" {
  source  = "edge.artifactory.ouroath.com:4443/terraform-modules__yahoo/tfstates/aws"
  version = "X.Y.Z" # Get the latest version from https://git.ouryahoo.com/terraform/terraform-aws-tfstates
  tags = {
    "corp:Environment" = local.environment
    "corp:Stack"       = "terraform-bootstrap"
    "corp:Application" = "terraform-bootstrap"
    "corp:Owner"       = "YOUR_TEAM@yahooinc.com"
    ManagedBy          = "https://git.ouryahoo.com/YOUR_ORG/YOUR_REPOSITORY/tree/main/terraform/environments/${local.environment}-${var.aws_region}"
  }
}
