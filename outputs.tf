output "sp_name" {
  description = "Azure Service Principal name."
  value       = azuread_application.aad_app.display_name
}

output "sp_app_id" {
  description = "Azure Service Principal App ID."
  value       = azuread_application.aad_app.application_id
}

output "sp_object_id" {
  description = "Azure Service Principal Object ID."
  value       = azuread_service_principal.sp.object_id
}

output "sp_secret_key" {
  description = "Azure Service Principal secret key/password."
  value       = azuread_service_principal_password.sp_pwd.value
  sensitive   = true
}

output "sp_validity_end_date" {
  description = "Azure Service Principal validity date."
  value       = azuread_service_principal_password.sp_pwd.end_date
}

output "sp_role_scope_assignment" {
  description = "Azure Service Principal assigned roles and scopes."
  value       = { for r in var.sp_scope_assignment : r.scope => coalesce(r.role_id, r.role_name) }
}

output "sp_aad_group" {
  description = "Azure Service Principal AAD groups membership."
  value       = var.sp_group_member
}
