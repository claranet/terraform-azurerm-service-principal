output "resource" {
  description = "Azure Service Principal resource object."
  value       = azuread_service_principal.main
}

output "id" {
  description = "Azure Service Principal ID."
  value       = azuread_application.main.id
}

output "name" {
  description = "Azure Service Principal name."
  value       = azuread_application.main.display_name
}

output "app_id" {
  description = "Azure Service Principal App ID."
  value       = azuread_application.main.client_id
}

output "object_id" {
  description = "Azure Service Principal Object ID."
  value       = azuread_service_principal.main.object_id
}

output "secret_key" {
  description = "Azure Service Principal secret key/password."
  value       = azuread_service_principal_password.main.value
  sensitive   = true
}

output "validity_end_date" {
  description = "Azure Service Principal validity date."
  value       = azuread_service_principal_password.main.end_date
}

output "role_scope_assignment" {
  description = "Azure Service Principal assigned roles and scopes."
  value       = { for r in var.scope_assignment : format("%s-%s", r.scope, coalesce(r.role_id, r.role_name)) => r }
}

output "entra_groups" {
  description = "Azure Service Principal Entra ID groups membership."
  value       = var.groups_member
}

output "required_resource_access" {
  description = "Azure Service Principal required resource access."
  value       = azuread_application.main.required_resource_access
}
