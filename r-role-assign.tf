resource "azurerm_role_assignment" "main" {
  for_each = { for scope_assignment in var.scope_assignment : format("%s-%s", scope_assignment.scope, coalesce(scope_assignment.role_id, scope_assignment.role_name)) => scope_assignment }

  scope                = each.value.scope
  role_definition_name = each.value.role_id == null ? each.value.role_name : null
  role_definition_id   = each.value.role_id
  principal_id         = azuread_service_principal.main.object_id

  delegated_managed_identity_resource_id = each.value.delegated_managed_identity_resource_id
  skip_service_principal_aad_check       = each.value.skip_service_principal_aad_check
}

moved {
  from = azurerm_role_assignment.sp_role
  to   = azurerm_role_assignment.main
}
