resource "azurerm_role_assignment" "sp_role" {
  for_each = toset(var.sp_scope_assignment)

  scope                = each.value.scope
  role_definition_name = each.value.role_id == null ? each.value.role_name : null
  role_definition_id   = each.value.role_id
  principal_id         = azuread_service_principal.sp.object_id

  delegated_managed_identity_resource_id = each.value.delegated_managed_identity_resource_id
  skip_service_principal_aad_check       = each.value.skip_service_principal_aad_check
}
