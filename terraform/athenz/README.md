# athenz
This directory is to manage the Athenz domains:
- https://ui.athenz.ouroath.com/domain/<DEV_ATHENZ_DOMAIN>/role
- https://ui.athenz.ouroath.com/domain/<PROD_ATHENZ_DOMAIN>/role
In this root directory, we will use these placeholders:
| Placeholders            | Description                                                                                                                                                                                     |
|-------------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `<ATHENZ_DOMAIN>`       | Your common part of Athenz domain. Eg: `your-domain`.                                                                                                                                           |
| `<DEV_ATHENZ_DOMAIN>`   | Your dev Athenz domain. Eg: `your-domain.dev`.                                                                                                                                                  |
| `<DEV_AWS_ACCOUNT_ID>`  | Your dev AWS account ID. Eg: `111111111111`.                                                                                                                                                    |
| `<DEV_AWS_REGION>`      | The AWS region where you want to store the Terraform state file (eg: `us-east-1`).                                                                                                              |
| `<PROD_ATHENZ_DOMAIN>`  | Your prod Athenz domain. Eg: `your-domain.prod`.                                                                                                                                                |
| `<PROD_AWS_ACCOUNT_ID>` | Your prod AWS account ID. Eg: `222222222222`.                                                                                                                                                   |
| `<PROD_AWS_REGION>`     | The AWS region where you want to store the Terraform state file (eg: `us-east-1`).                                                                                                              |
| `YOUR_ORG`              | Your GitHub organization name.                                                                                                                                                                  |
| `YOUR_REPOSITORY`       | Your GitHub repository name.                                                                                                                                                                    |
| `<YOUR_SHORT_ID>`       | Your Short ID.                                                                                                                                                                                  |
| `<SD_PIPELINE_ID>`      | Your Screwdriver pipeline ID. When you create a Screwdriver pipeline, its URL is in the form https://screwdriver.ouroath.com/pipelines/1234567 . `1234567` is your **Screwdriver pipeline ID**. |
If you see these placeholders, you should replace them by your own values.
# Understanding the structure
Here is the file tree of this `athenz` directory:
```
athenz
|-- <DEV_ATHENZ_DOMAIN>
|   |-- backend.tf
|   |-- common-locals.tf -> ../common/common-locals.tf
|   |-- common-policies.tf -> ../common/common-policies.tf
|   |-- common-roles.tf -> ../common/common-roles.tf
|   |-- common-services.tf -> ../common/common-services.tf
|   |-- main.tf
|   |-- policies.tf
|   |-- roles.tf
|   `-- versions.tf -> ../common/versions.tf
|-- <PROD_ATHENZ_DOMAIN>
|   |-- backend.tf
|   |-- common-locals.tf -> ../common/common-locals.tf
|   |-- common-policies.tf -> ../common/common-policies.tf
|   |-- common-roles.tf -> ../common/common-roles.tf
|   |-- common-services.tf -> ../common/common-services.tf
|   |-- main.tf
|   |-- policies.tf
|   |-- roles.tf
|   `-- versions.tf -> ../common/versions.tf
`-- common
    |-- common-locals.tf
    |-- common-policies.tf
    |-- common-roles.tf
    |-- common-services.tf
    `-- versions.tf
```
As you can see, the files in the `common` directory are symlinked in the `<DEV_ATHENZ_DOMAIN>` and
`<PROD_ATHENZ_DOMAIN>` directories. As a consequence, anything you write in these files will be present in BOTH
`<DEV_ATHENZ_DOMAIN>` and `<PROD_ATHENZ_DOMAIN>` Athenz domains.
This ensures that you have a prefect **symmetry** between the 2 Athenz domains `<DEV_ATHENZ_DOMAIN>` and
`<PROD_ATHENZ_DOMAIN>`.
## How to add new Athenz resources (role, service, policy, etc.)
If that resource is meant to be in:
<table>
<tr>
<th>BOTH Athenz domains</th>
<td>
Add it in one of the files:
<ul>
<li><code>common-policies.tf</code></li>
<li><code>common-roles.tf</code></li>
<li><code>common-services.tf</code></li>
</ul>
</td>
</tr>
<tr>
<th>ONLY in one Athenz domain</th>
<td>
Add it under the <code>&lt;DEV_ATHENZ_DOMAIN&gt;</code> or <code>&lt;PROD_ATHENZ_DOMAIN&gt;</code> directory in one of
the files:
<ul>
<li><code>policies.tf</code></li>
<li><code>roles.tf</code></li>
<li><code>services.tf</code></li>
</ul>
</td>
</tr>
</table>
Of course, if you need to add Athenz groups, you're free to add files `common-groups.tf` and `groups.tf`, or anything
else that you see fit. Ultimately, you OWN all these directories: it is YOUR infrastructure.
### Example
For example, you want to create a new role `foo`.
In `terraform/athenz/common/common-roles.tf`, add:
```hcl
resource "athenz_role" "foo" {
  domain  = local.domain
  name    = "foo"
 
  dynamic "member" {
    for_each = local.role_foo_members
    content {
      name = member.value
    }
  }
}
```
This role will be created in **both `<DEV_ATHENZ_DOMAIN>` & `<PROD_ATHENZ_DOMAIN>` domains**.
In `terraform/athenz/<DEV_ATHENZ_DOMAIN>/roles.tf`:
```hcl
locals {
  role_foo_members = [
    "user.member1",
    "user.member2",
  ]
}
```
Likewise in `terraform/athenz/<PROD_ATHENZ_DOMAIN>/roles.tf`.
# Bootstrap the Athenz domains management
1. Replace the placeholders at the top of this README:
   - `https://ui.athenz.ouroath.com/domain/<DEV_ATHENZ_DOMAIN>/role`
   - `https://ui.athenz.ouroath.com/domain/<PROD_ATHENZ_DOMAIN>/role`
2. Rename the directories to your dev & prod Athenz domains:
   - `<DEV_ATHENZ_DOMAIN>`
   - `<PROD_ATHENZ_DOMAIN>`
3. Under `<DEV_ATHENZ_DOMAIN>` and `<PROD_ATHENZ_DOMAIN>` directories, replace the placeholder in the files
   `common-locals.tf`:
    ```hcl
    # YOUR_ORG/YOUR_REPOSITORY
    sd_id_your_org_your_repository    = "cd.screwdriver.project.sd<SD_PIPELINE_ID>"
    sd_id_your_org_your_repository_pr = "cd.screwdriver.project.sd<SD_PIPELINE_ID>pr"
    ```
    let's say:
    - your repository URL is https://git.ouryahoo.com/acme/your-domain-infrastructure
    - your `<SD_PIPELINE_ID>` is `1234567`.
    the placeholder changes would look like this:
    ```hcl
    # acme/your-domain-infrastructure
    sd_id_acme_foo_domain_infrastructure    = "cd.screwdriver.project.sd1234567"
    sd_id_acme_foo_domain_infrastructure_pr = "cd.screwdriver.project.sd1234567pr"
    ```
4. Under `<DEV_ATHENZ_DOMAIN>` and `<PROD_ATHENZ_DOMAIN>` directories, replace the placeholders in the files:
   - `backend.tf`
   - `main.tf`
   - `roles.tf` (don't forget to rename the `sd_id_your_org_your_repository` and `sd_id_your_org_your_repository_pr`
     local variables)
5. **Pin the latest module version** in the `common/common-modules.tf` file.
Now we need to **import the existing Athenz resources**, but to do that, we need to be able to run Terraform locally
from your laptop.
We assume that you installed the prerequisites in the root [README](/../..).
## Refresh your Athenz & AWS credentials
Refresh your Athenz cert & key:
```bash
yinit
athenz-user-cert
# Or to force Athenz cert & key to refresh
athenz-user-cert -r
```
Refresh your AWS credentials by selecting AWS account (dev or prod) depending which domain you want to work on:
```bash
awsfed2
```
## Apply the TF configuration from your laptop
For example for the `<DEV_ATHENZ_DOMAIN>`, run:
```bash
cd terraform/athenz/<DEV_ATHENZ_DOMAIN>
terraform init
terraform providers lock -platform=linux_amd64
terraform apply
```
You might see errors about **already existing resources**. Most probably, you would like to import these existing
resources.
## (Recommended) How to import already existing Athenz resources into Terraform using `ytf`
Install [`ytf`](http://yo/ytf).
After adding the Athenz resources (roles, services, policies, etc.) that are already existing in your Athenz domain, in
your Terraform `.tf` files, all you have to do it to run:
```bash
terraform init
ytf generate imports
```
`ytf` will generate a file `generated-imports.tf` which will import the already existing Athenz resources upon
`terraform apply`.
You can then run again this to make sure everything is in-sync with your code or fix the differences:
```bash
terraform apply
```
## How to import already existing Athenz resources into Terraform manually
Add the Athenz resource (role, service, policy, etc.) in the right `.tf` file as if you would like to create a new
resource, but instead of running `terraform apply`, you need to run `terraform import`.
### How to import an Athenz role
```bash
terraform import athenz_role.<ROLE_TF_VAR_NAME> <ATHENZ_DOMAIN>:role.<ROLE_NAME>
```
For example, if I have this role in the code:
```hcl
resource "athenz_role" "aws_fed_admin_user" {
  domain  = "your-domain"
  name    = "aws.fed.admin.user"
}
```
- `<ROLE_TF_VAR_NAME>` = `aws_fed_admin_user` (The Terraform variable name in the Terraform code)
- `<ROLE_NAME>` = `aws.fed.admin.user` (The Athenz role name)
the `terraform import` command would be:
```bash
terraform import athenz_role.aws_fed_admin_user your-domain.dev:role.aws.fed.admin.user
terraform import athenz_role.aws_fed_admin_user your-domain.prod:role.aws.fed.admin.user
```
### How to import an Athenz group
```bash
terraform import athenz_group.<GROUP_TF_VAR_NAME> <ATHENZ_DOMAIN>:group.<GROUP_NAME> 
```
For example, if I have this group in the code:
```hcl
resource "athenz_group" "dev_core" {
  domain  = "your-domain"
  name    = "dev-core"
}
```
- `<GROUP_TF_VAR_NAME>` = `dev_core` (The Terraform variable name in the Terraform code)
- `<GROUP_NAME>` = `dev-core` (The Athenz group name)
the `terraform import` command would be:
```bash
terraform import athenz_group.dev_core your-domain.dev:group.dev-core 
terraform import athenz_group.dev_core your-domain.prod:group.dev-core
```
### How to import an Athenz service
```bash
terraform import athenz_service.<SERVICE_TF_VAR_NAME> <ATHENZ_DOMAIN>.<SERVICE_NAME>
```
For example, if I have this service in the code:
```hcl
resource "athenz_service" "api_user" {
  domain = "your-domain"
  name   = "api-user"
}
```
- `<SERVICE_TF_VAR_NAME>` = `api_user` (The Terraform variable name in the Terraform code)
- `<SERVICE_NAME>` = `api-user` (The Athenz service name)
the `terraform import` command would be:
```bash
terraform import athenz_service.api_user your-domain.dev.api-user
terraform import athenz_service.api_user your-domain.prod.api-user
```
### How to import an Athenz policy
```bash
terraform import athenz_policy.<POLICY_TF_VAR_NAME> <ATHENZ_DOMAIN>:policy.<POLICY_NAME>
```
For example, if I have this policy in the code:
```hcl
resource "athenz_policy" "aws_ssh_login" {
  domain = "your-domain"
  name   = "aws.ssh_login"
  assertion {
    effect   = "ALLOW"
    action   = "ssh_login"
    role     = "aws.ssh_login"
    resource = "your-domain:aws.api-user.*"
  }
}
```
- `<POLICY_TF_VAR_NAME>` = `aws_ssh_login` (The Terraform variable name in the Terraform code)
- `<POLICY_NAME>` = `aws.ssh_login` (The Athenz service name)
the `terraform import` command would be:
```bash
terraform import athenz_policy.aws_ssh_login your-domain.dev:policy.aws.ssh_login
terraform import athenz_policy.aws_ssh_login your-domain.prod:policy.aws.ssh_login
```
# Documentation reference
All the Athenz Terraform resources are documented here:
https://registry.terraform.io/providers/AthenZ/athenz/
# Troubleshooting
## `terraform apply`: "remote error: tls: unknown certificate"
It means that your Athenz cert & key files are not valid.
If you're on your laptop, run:
```bash
athenz-user-cert -r
```
and make sure that your cert is valid:
```bash
openssl x509 -in ~/.athenz/cert -noout -dates
```
# FAQ
## Why didn't you use a Terraform module for common resources instead of symlinks?
Because of cyclic dependencies between Athenz role, service, policies.
Imagine that we have a Terraform module for common resources like this:
```hcl
resource "athenz_service" "ec2" {
  domain = var.domain
  name   = "ec2"
}
resource "athenz_policy" "aws_instance_launch_provider" {
  domain = var.domain
  name   = "aws_instance_launch_provider"
  assertion = [
    for resource in var.policy_aws_instance_launch_provider_resources :
    {
      effect   = "ALLOW"
      action   = "launch"
      role     = "aws_instance_launch_provider"
      resource = resource
    }
  ]
}
output "athenz_service_ec2" {
  value = athenz_service.ec2
}
```
From the caller directory:
```hcl
module "common" {
  domain = local.domain
  policy_aws_instance_launch_provider_resources = [
    # Cyclic dependency! This Athenz service is not defined until the common module is executed!
    "service.${module.common.athenz_service_ec2.name}",
  ]
}
```
