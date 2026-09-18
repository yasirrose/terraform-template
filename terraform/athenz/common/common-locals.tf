locals {
  cd_deploy_iam_role    = "cd-deploy"
  cd_deploy_pr_iam_role = "cd-deploy-pr"
  # SD pipeline IDs (keep them sorted in alphabetical order for readability)
  # YOUR_ORG/YOUR_REPOSITORY
  sd_id_your_org_your_repository    = "cd.screwdriver.project.sd<SD_PIPELINE_ID>"
  sd_id_your_org_your_repository_pr = "cd.screwdriver.project.sd<SD_PIPELINE_ID>pr"
}
