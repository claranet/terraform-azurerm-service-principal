resource "azuread_application" "aad_app" {
  display_name = var.sp_display_name
  owners       = var.sp_owners
  tags         = var.sp_aad_app_tags

  prevent_duplicate_names = true
  identifier_uris         = var.identifier_uris

  dynamic "required_resource_access" {
    for_each = var.sp_required_resource_access
    content {
      resource_app_id = required_resource_access.key
      dynamic "resource_access" {
        for_each = required_resource_access.value
        content {
          id   = resource_access.value.resource_access_id
          type = resource_access.value.resource_access_type
        }
      }
    }
  }

  dynamic "api" {
    for_each = var.api_settings[*]
    content {
      known_client_applications      = api.value.known_client_applications
      mapped_claims_enabled          = api.value.mapped_claims_enabled
      requested_access_token_version = api.value.requested_access_token_version
      dynamic "oauth2_permission_scope" {
        for_each = api.value.oauth2_permission_scopes
        content {
          admin_consent_description  = oauth2_permission_scope.value.admin_consent_description
          admin_consent_display_name = oauth2_permission_scope.value.admin_consent_display_name
          enabled                    = oauth2_permission_scope.value.enabled
          id                         = coalesce(oauth2_permission_scope.value.id, random_uuid.api_settings[oauth2_permission_scope.value.admin_consent_display_name].result)
          type                       = oauth2_permission_scope.value.type
          user_consent_description   = oauth2_permission_scope.value.user_consent_description
          user_consent_display_name  = oauth2_permission_scope.value.user_consent_display_name
          value                      = oauth2_permission_scope.value.value
        }
      }
    }
  }

  dynamic "web" {
    for_each = var.web_settings[*]
    content {
      homepage_url  = web.value.homepage_url
      logout_url    = web.value.logout_url
      redirect_uris = web.value.redirect_uris
      implicit_grant {
        access_token_issuance_enabled = web.value.access_token_issuance_enabled
        id_token_issuance_enabled     = web.value.id_token_issuance_enabled
      }
    }
  }
}

resource "azuread_service_principal" "sp" {
  client_id = azuread_application.aad_app.client_id
  owners    = var.sp_owners

  app_role_assignment_required = false
}

resource "azuread_service_principal_password" "sp_pwd" {
  service_principal_id = azuread_service_principal.sp.id
  end_date_relative    = var.sp_token_validity_duration
}

resource "random_uuid" "api_settings" {
  for_each = toset(try([for api in var.api_settings.oauth2_permission_scopes : api.admin_consent_display_name], []))
}
