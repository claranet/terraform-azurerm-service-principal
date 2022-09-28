data "azurerm_subscription" "primary" {
}

data "azurerm_resource_group" "rg" {
  name = "dsrg_test"
}

data "azuread_group" "readers" {
  display_name = "Claranet Readers"
}

resource "azurerm_role_definition" "example" {
  role_definition_id = "00000000-0000-0000-0000-000000000000"
  name               = "my-custom-role-definition"
  scope              = data.azurerm_subscription.primary.id

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
