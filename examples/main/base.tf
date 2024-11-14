data "azurerm_subscription" "main" {
}

data "azurerm_resource_group" "main" {
  name = "dsrg_test"
}

data "azuread_group" "readers" {
  display_name = "Claranet Readers"
}

data "azuread_users" "owners" {
  user_principal_names = ["jean.dupont@xxxx.clara.net", "owner.yyyy@contoso.com"]
}

resource "azurerm_role_definition" "example" {
  name  = "my-custom-role-definition"
  scope = data.azurerm_subscription.main.id

  permissions {
    actions     = ["Microsoft.Resources/subscriptions/resourceGroups/read"]
    not_actions = []
  }

  assignable_scopes = [
    data.azurerm_subscription.main.id,
  ]
}
