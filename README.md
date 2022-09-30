# Azure Service Principal
[![Changelog](https://img.shields.io/badge/changelog-release-green.svg)](CHANGELOG.md) [![Notice](https://img.shields.io/badge/notice-copyright-yellow.svg)](NOTICE) [![Apache V2 License](https://img.shields.io/badge/license-Apache%20V2-orange.svg)](LICENSE) [![TF Registry](https://img.shields.io/badge/terraform-registry-blue.svg)](https://registry.terraform.io/modules/claranet/service-principal/azurerm/)

Azure terraform module to create an Azure AD Service Principal and assign specified role(s) to choosen Azure scope(s).

<!-- BEGIN_TF_DOCS -->
## Global versioning rule for Claranet Azure modules

| Module version | Terraform version | AzureRM version |
| -------------- | ----------------- | --------------- |
| >= 7.x.x       | 1.3.x             | >= 3.0          |
| >= 6.x.x       | 1.x               | >= 3.0          |
| >= 5.x.x       | 0.15.x            | >= 2.0          |
| >= 4.x.x       | 0.13.x / 0.14.x   | >= 2.0          |
| >= 3.x.x       | 0.12.x            | >= 2.0          |
| >= 2.x.x       | 0.12.x            | < 2.0           |
| <  2.x.x       | 0.11.x            | < 2.0           |

## Usage

This module is optimized to work with the [Claranet terraform-wrapper](https://github.com/claranet/terraform-wrapper) tool
which set some terraform variables in the environment needed by this module.
More details about variables set by the `terraform-wrapper` available in the [documentation](https://github.com/claranet/terraform-wrapper#environment).

```hcl
data "azurerm_subscription" "primary" {
}

data "azurerm_resource_group" "rg" {
  name = "dsrg_test"
}

data "azuread_group" "readers" {
  display_name = "Claranet Readers"
}

resource "azurerm_role_definition" "example" {
  name  = "my-custom-role-definition"
  scope = data.azurerm_subscription.primary.id

  permissions {
    actions     = ["Microsoft.Resources/subscriptions/resourceGroups/read"]
    not_actions = []
  }

  assignable_scopes = [
    data.azurerm_subscription.primary.id,
  ]
}

module "sp" {
  source  = "claranet/service-principal/azurerm"
  version = "x.x.x"

  sp_display_name = "claranet-tools"

  sp_scope_assignment = [
    {
      scope     = data.azurerm_subscription.primary.id
      role_name = null
      role_id   = azurerm_role_definition.example.role_definition_resource_id
    },
    {
      scope     = data.azurerm_resource_group.rg.id
      role_name = "Contributor"
    }
  ]

  sp_group_member = {
    (data.azuread_group.readers.display_name) = data.azuread_group.readers.object_id
  }
}
```

## Providers

| Name | Version |
|------|---------|
| azuread | ~> 2.0 |
| azurerm | ~> 3.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azuread_application.aad_app](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/application) | resource |
| [azuread_group_member.sp_group_member](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/group_member) | resource |
| [azuread_service_principal.sp](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/service_principal) | resource |
| [azuread_service_principal_password.sp_pwd](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/service_principal_password) | resource |
| [azurerm_role_assignment.sp_role](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| sp\_display\_name | Azure Service Principal (and AAD application) display name. | `string` | n/a | yes |
| sp\_groups\_member | Map of AAD Groups (group name => object ID) to add this Service Principal. | `map(string)` | `{}` | no |
| sp\_scope\_assignment | List of object representing the scopes and roles to assign the Service Principal with. | <pre>list(object({<br>    scope     = string<br>    role_name = optional(string, "Reader")<br>    role_id   = optional(string)<br><br>    delegated_managed_identity_resource_id = optional(string)<br>    skip_service_principal_aad_check       = optional(bool, false)<br>  }))</pre> | `[]` | no |
| sp\_token\_validity\_duration | Azure Service Principal token/password duration before it expires. Defaults to 2 years. Notation documentation: https://pkg.go.dev/time#ParseDuration | `string` | `"17520h"` | no |

## Outputs

| Name | Description |
|------|-------------|
| sp\_aad\_groups | Azure Service Principal AAD groups membership. |
| sp\_app\_id | Azure Service Principal App ID. |
| sp\_name | Azure Service Principal name. |
| sp\_object\_id | Azure Service Principal Object ID. |
| sp\_role\_scope\_assignment | Azure Service Principal assigned roles and scopes. |
| sp\_secret\_key | Azure Service Principal secret key/password. |
| sp\_validity\_end\_date | Azure Service Principal validity date. |
<!-- END_TF_DOCS -->
## Related documentation

Azure Lock management documentation: [docs.microsoft.com/en-us/azure/azure-resource-manager/management/lock-resources](https://docs.microsoft.com/en-us/azure/azure-resource-manager/management/lock-resources?tabs=json)
