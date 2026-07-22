resource "azuread_application_federated_identity_credential" "main" {
  for_each = { for k, v in var.federated_identity_credentials : k => v if v.subject != null }

  application_id = azuread_application.main.id
  display_name   = each.value.display_name
  description    = each.value.description
  issuer         = each.value.issuer
  subject        = each.value.subject
  audiences      = each.value.audiences
}

resource "azuread_application_flexible_federated_identity_credential" "main" {
  for_each = { for k, v in var.federated_identity_credentials : k => v if v.claims_matching_expression != null }

  application_id             = azuread_application.main.id
  display_name               = each.value.display_name
  description                = each.value.description
  issuer                     = each.value.issuer
  claims_matching_expression = each.value.claims_matching_expression
  audience                   = each.value.audience
}
