# Keep the resources sorted alphabetically (it makes it easier to find them)
resource "athenz_service" "bastion" {
  domain      = local.domain
  name        = "bastion"
  description = "AWS Bastion Instance Service"
}
