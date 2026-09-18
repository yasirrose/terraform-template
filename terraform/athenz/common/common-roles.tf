# Keep the resources sorted alphabetically (it makes it easier to find them)
resource "athenz_role" "admin" {
  domain = local.domain
  name   = "admin"
  dynamic "member" {
    for_each = local.role_admin_members
    content {
      name = member.value
    }
  }
}
resource "athenz_role" "admin_cd" {
  domain = local.domain
  name   = "admin.cd"
  dynamic "member" {
    for_each = local.role_admin_cd_members
    content {
      name = member.value
    }
  }
}
resource "athenz_role" "aws_fed_admin_user" {
  domain = local.domain
  name   = "aws.fed.admin.user"
  dynamic "member" {
    for_each = local.role_aws_fed_admin_user_members
    content {
      name = member.value
    }
  }
}
resource "athenz_role" "aws_fed_power_user" {
  domain = local.domain
  name   = "aws.fed.power.user"
  dynamic "member" {
    for_each = local.role_aws_fed_power_user_members
    content {
      name = member.value
    }
  }
}
resource "athenz_role" "aws_ssh_login" {
  domain = local.domain
  name   = "aws.ssh_login"
  dynamic "member" {
    for_each = local.role_aws_ssh_login_members
    content {
      name = member.value
    }
  }
}
