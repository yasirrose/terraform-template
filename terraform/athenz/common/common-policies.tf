# Keep the resources sorted alphabetically (it makes it easier to find them)
resource "athenz_policy" "admin_cd" {
  domain = local.domain
  name   = athenz_role.admin_cd.name
  dynamic "assertion" {
    for_each = [
      "${local.domain}:group.*",
      "${local.domain}:policy.*",
      "${local.domain}:role.*",
      "${local.domain}:service.*",
    ]
    content {
      effect   = "ALLOW"
      action   = "*"
      role     = athenz_role.admin_cd.name
      resource = assertion.value
    }
  }
  assertion {
    effect   = "ALLOW"
    action   = "update"
    role     = athenz_role.admin_cd.name
    resource = "${local.domain}:ums"
  }
}
resource "athenz_policy" "aws_instance_launch_provider" {
  domain = local.domain
  name   = "aws_instance_launch_provider"
  dynamic "assertion" {
    for_each = local.policy_aws_instance_launch_provider_resources
    content {
      effect   = "ALLOW"
      action   = "launch"
      role     = "aws_instance_launch_provider"
      resource = assertion.value
    }
  }
}
resource "athenz_policy" "aws_ssh_login" {
  domain = local.domain
  name   = athenz_role.aws_ssh_login.name
  # Remove this DENY block if you enable `bastion-cli --bastion-enable-shell-access`
  assertion {
    effect   = "DENY"
    action   = "ssh_login"
    role     = athenz_role.aws_ssh_login.name
    resource = "${local.domain}:aws.${athenz_service.bastion.name}.*"
  }
  dynamic "assertion" {
    for_each = local.policy_aws_ssh_login_resources
    content {
      effect   = "ALLOW"
      action   = "ssh_login"
      role     = athenz_role.aws_ssh_login.name
      resource = assertion.value
    }
  }
}
