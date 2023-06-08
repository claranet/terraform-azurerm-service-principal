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

  sp_required_resource_access = [
    {
      resource_app_id      = "4f6778d8-5aef-43dc-a1ff-b073724b9495" # Azure Healthcare APIs
      resource_access_id   = "db75143a-8f20-4238-9450-8b73ef4992f4" # user_impersonation - Delegated
      resource_access_type = "Scope"
    },
    {
      resource_app_id      = "00000003-0000-0000-c000-000000000000" # Microsoft.Graph
      resource_access_id   = "e1fe6dd8-ba31-4d61-89e7-88639da4683d" # User.Read - Delegated
      resource_access_type = "Scope"
    }
  ]
}
