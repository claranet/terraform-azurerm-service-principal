resource "azuread_application" "aad_app" {
  display_name = var.sp_display_name
  owners       = var.sp_owners
  tags         = var.sp_aad_app_tags

  prevent_duplicate_names = true
}

resource "azuread_service_principal" "sp" {
  application_id = azuread_application.aad_app.application_id
  owners         = var.sp_owners

  app_role_assignment_required = false
}

resource "azuread_service_principal_password" "sp_pwd" {
  service_principal_id = azuread_service_principal.sp.id
  end_date_relative    = var.sp_token_validity_duration
}
