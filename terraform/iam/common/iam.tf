module "zts_oidc_provider" {
  source  = "edge.artifactory.ouroath.com:4443/terraform-modules__yahoo/iam/aws//modules/athenz-oidc-provider"
  version = "~> 0.1" # Get the latest version from https://git.ouryahoo.com/terraform/terraform-aws-iam
  client_id_list = [
    "${local.athenz_domain}.oidc:${local.athenz_domain}:role.aws.fed.admin.user",
    "${local.athenz_domain}.oidc:${local.athenz_domain}:role.aws.fed.power.user",
    "${local.athenz_domain}.oidc:${local.athenz_domain}:role.aws.fed.read.only",
    "${local.athenz_domain}.oidc:${local.athenz_domain}:role.${module.cd_deploy.cd_deploy_athenz_role}",
    "${local.athenz_domain}.oidc:${local.athenz_domain}:role.${module.cd_deploy.cd_deploy_pr_athenz_role}",
  ]
}
# IAM roles `cd-deploy` and `cd-deploy-pr`
module "cd_deploy" {
  source  = "edge.artifactory.ouroath.com:4443/terraform-modules__yahoo/iam/aws//modules/aws-cd-deploy"
  version = "X.Y.Z" # Get the latest version from https://git.ouryahoo.com/terraform/terraform-aws-iam
  athenz_domain = local.athenz_domain
  add_tfstates_management_policy               = true
  add_iam_roles_and_policies_management_policy = true
  cd_deploy_allow_athenz_oidc_assume_role = true
  cd_deploy_managed_policy_arns = [
    module.iam_policy_for_athenz_oidc_provider.read_write_iam_policy.arn,
    module.iam_policy_for_tfstates_access.read_write_iam_policy.arn,
  ]
  cd_deploy_pr_allow_athenz_oidc_assume_role = true
  cd_deploy_pr_managed_policy_arns = [
    module.iam_policy_for_athenz_oidc_provider.read_only_iam_policy.arn,
    module.iam_policy_for_tfstates_access.read_only_iam_policy.arn,
  ]
}
module "iam_policy_for_tfstates_access" {
  source  = "edge.artifactory.ouroath.com:4443/terraform-modules__yahoo/iam/aws//modules/iam-policy-for-tfstates-access"
  version = "X.Y.Z" # Get the latest version from https://git.ouryahoo.com/terraform/terraform-aws-iam
  # The regions where you have TF states buckets
  aws_regions = [
    "<AWS_REGION>",
  ]
  tags = merge(local.common_tags, {
    "corp:Application" = "cd-deploy"
  })
}
module "iam_policy_for_athenz_oidc_provider" {
  source = "edge.artifactory.ouroath.com:4443/terraform-modules__yahoo/iam/aws//modules/iam-policy-for-athenz-oidc-provider"
}
