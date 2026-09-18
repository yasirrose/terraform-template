# Keep the resources sorted alphabetically (it makes it easier to find them)
module "cd_deploy" {
  source  = "edge.artifactory.ouroath.com:4443/terraform-modules__yahoo/modules/athenz//modules/aws-cd-deploy"
  version = "X.Y.Z" # Get the latest version from https://git.ouryahoo.com/terraform/terraform-athenz-modules
  domain = local.domain
  # cd.deploy
  cd_deploy_iam_role_name       = local.cd_deploy_iam_role
  cd_deploy_athenz_role_members = [for m in local.role_aws_cd_deploy_members : { name = m }]
  # cd.deploy-pr
  cd_deploy_pr_iam_role_name       = local.cd_deploy_pr_iam_role
  cd_deploy_pr_athenz_role_members = [for m in local.role_aws_cd_deploy_pr_members : { name = m }]
}
