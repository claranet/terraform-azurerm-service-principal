resource "azuread_group_member" "sp_group_member" {
  for_each = var.sp_groups_member

  group_object_id  = each.value
  member_object_id = azuread_service_principal.sp.object_id
}
