resource "azuread_group_member" "main" {
  for_each = var.groups_member

  group_object_id  = each.value
  member_object_id = azuread_service_principal.main.object_id
}

moved {
  from = azuread_group_member.sp_group_member
  to   = azuread_group_member.main
}
