# Azure Service Principal
[![Changelog](https://img.shields.io/badge/changelog-release-green.svg)](CHANGELOG.md) [![Notice](https://img.shields.io/badge/notice-copyright-blue.svg)](NOTICE) [![Apache V2 License](https://img.shields.io/badge/license-Apache%20V2-orange.svg)](LICENSE) [![OpenTofu Registry](https://img.shields.io/badge/opentofu-registry-yellow.svg)](https://search.opentofu.org/module/claranet/service-principal/azurerm/)

Azure terraform module to create an Azure AD Service Principal and assign specified role(s) to choosen Azure scope(s).

<!-- BEGIN_TF_DOCS -->
## Global versioning rule for Claranet Azure modules

| Module version | Terraform version | OpenTofu version | AzureRM version |
| -------------- | ----------------- | ---------------- | --------------- |
| >= 8.x.x       | **Unverified**    | 1.8.x            | >= 4.0          |
| >= 7.x.x       | 1.3.x             |                  | >= 3.0          |
| >= 6.x.x       | 1.x               |                  | >= 3.0          |
| >= 5.x.x       | 0.15.x            |                  | >= 2.0          |
| >= 4.x.x       | 0.13.x / 0.14.x   |                  | >= 2.0          |
| >= 3.x.x       | 0.12.x            |                  | >= 2.0          |
| >= 2.x.x       | 0.12.x            |                  | < 2.0           |
| <  2.x.x       | 0.11.x            |                  | < 2.0           |

## Contributing

If you want to contribute to this repository, feel free to use our [pre-commit](https://pre-commit.com/) git hook configuration
which will help you automatically update and format some files for you by enforcing our Terraform code module best-practices.

More details are available in the [CONTRIBUTING.md](./CONTRIBUTING.md#pull-request-process) file.

## Usage

This module is optimized to work with the [Claranet terraform-wrapper](https://github.com/claranet/terraform-wrapper) tool
which set some terraform variables in the environment needed by this module.
More details about variables set by the `terraform-wrapper` available in the [documentation](https://github.com/claranet/terraform-wrapper#environment).

⚠️ Since modules version v8.0.0, we do not maintain/check anymore the compatibility with
[Hashicorp Terraform](https://github.com/hashicorp/terraform/). Instead, we recommend to use [OpenTofu](https://github.com/opentofu/opentofu/).

```hcl
data "azurerm_subscription" "primary" {
}

data "azurerm_resource_group" "rg" {
  name = "dsrg_test"
}

data "azuread_group" "readers" {
  display_name = "Claranet Readers"
}

data "azuread_users" "owner_users" {
  user_principal_names = ["jean.dupont@xxxx.clara.net", "owner.yyyy@contoso.com"]
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
  sp_owners       = data.azuread_users.owner_users.object_ids

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

  sp_groups_member = {
    (data.azuread_group.readers.display_name) = data.azuread_group.readers.object_id
  }

  sp_aad_app_tags = ["foo", "bar"]

  # az ad sp list --display-name "Microsoft Graph" --query '[].{appDisplayName:appDisplayName, appId:appId}'
  sp_required_resource_access = {
    # Azure Healthcare APIs
    "4f6778d8-5aef-43dc-a1ff-b073724b9495" = [{
      resource_access_id   = "4f6778d8-5aef-43dc-a1ff-b073724b9495" # user_impersonation - Application
      resource_access_type = "Role"
    }]
    # Microsoft.Graph
    "00000003-0000-0000-c000-000000000000" = [{
      resource_access_id   = "e1fe6dd8-ba31-4d61-89e7-88639da4683d" # User.Read - Delegated
      resource_access_type = "Scope"
      },
      {
        resource_access_id   = "19dbc75e-c2e2-444c-a770-ec69d8559fc7" # Directory.ReadWrite.All - Delegated
        resource_access_type = "Scope"
      }
    ]
  }
}
```

## Providers

| Name | Version |
|------|---------|
| azuread | ~> 3.0 |
| azurerm | ~> 3.0 |
| random | ~> 3.5 |

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
| [random_uuid.api_settings](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/uuid) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| api\_settings | Settings for the APIs you need to define using this Service Principal. | <pre>object({<br/>    known_client_applications      = optional(list(string), [])<br/>    mapped_claims_enabled          = optional(bool, false)<br/>    requested_access_token_version = optional(number, 1)<br/>    oauth2_permission_scopes = optional(list(object({<br/>      admin_consent_description  = string<br/>      admin_consent_display_name = string<br/>      enabled                    = optional(bool, true)<br/>      id                         = optional(string)<br/>      type                       = optional(string, "User")<br/>      user_consent_description   = optional(string)<br/>      user_consent_display_name  = optional(string)<br/>      value                      = optional(string)<br/>    })), [])<br/>  })</pre> | `{}` | no |
| identifier\_uris | A set of user-defined URI(s) that uniquely identify an application within its Azure AD tenant, or within a verified custom domain if the application is multi-tenant. | `list(string)` | `[]` | no |
| sp\_aad\_app\_tags | A set of tags to apply to the application. Tag values also propagate to any linked service principals. | `list(string)` | `[]` | no |
| sp\_display\_name | Azure Service Principal (and AAD application) display name. | `string` | n/a | yes |
| sp\_groups\_member | Map of AAD Groups (group name => object ID) to add this Service Principal. | `map(string)` | `{}` | no |
| sp\_owners | A set of object IDs of principals that will be granted ownership of both the AAD Application and associated Service Principal. Supported object types are users or service principals. | `list(string)` | `[]` | no |
| sp\_required\_resource\_access | List of Service Principal Application OAuth permission scopes configuration. https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/application#resource_access | <pre>map(list(object({<br/>    resource_access_id   = string<br/>    resource_access_type = string<br/>  })))</pre> | `{}` | no |
| sp\_scope\_assignment | List of object representing the scopes and roles to assign the Service Principal with. | <pre>list(object({<br/>    scope     = string<br/>    role_name = optional(string)<br/>    role_id   = optional(string)<br/><br/>    delegated_managed_identity_resource_id = optional(string)<br/>    skip_service_principal_aad_check       = optional(bool, false)<br/>  }))</pre> | `[]` | no |
| sp\_token\_validity\_duration | Azure Service Principal token/password duration before it expires. Defaults to 2 years. Notation documentation: https://pkg.go.dev/time#ParseDuration | `string` | `"17520h"` | no |
| web\_settings | Configuration for web related settings for this Service Principal. | <pre>object({<br/>    homepage_url                  = optional(string, null)<br/>    logout_url                    = optional(string, null)<br/>    redirect_uris                 = optional(list(string), [])<br/>    access_token_issuance_enabled = optional(bool)<br/>    id_token_issuance_enabled     = optional(bool)<br/>  })</pre> | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| sp\_aad\_groups | Azure Service Principal AAD groups membership. |
| sp\_app\_id | Azure Service Principal App ID. |
| sp\_name | Azure Service Principal name. |
| sp\_object\_id | Azure Service Principal Object ID. |
| sp\_required\_resource\_access | Azure Service Principal required resource access. |
| sp\_role\_scope\_assignment | Azure Service Principal assigned roles and scopes. |
| sp\_secret\_key | Azure Service Principal secret key/password. |
| sp\_validity\_end\_date | Azure Service Principal validity date. |
<!-- END_TF_DOCS -->
