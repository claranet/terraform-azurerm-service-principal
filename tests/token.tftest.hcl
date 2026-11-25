# Token (client secret) behaviour of the module, run with `tofu test`.
# Providers are mocked: no Azure credentials are needed and nothing is created in Entra ID.

mock_provider "azuread" {
  # The real provider validates these identifiers when they are passed to dependent resources
  mock_resource "azuread_application" {
    defaults = {
      id        = "/applications/00000000-0000-0000-0000-00000000000a"
      client_id = "00000000-0000-0000-0000-00000000000c"
    }
  }
  mock_resource "azuread_service_principal" {
    defaults = {
      id        = "/servicePrincipals/00000000-0000-0000-0000-00000000000b"
      object_id = "00000000-0000-0000-0000-00000000000b"
    }
  }
}

mock_provider "azurerm" {}

variables {
  display_name = "tftest-sp"
}

run "default_creates_one_service_principal_password" {
  assert {
    condition     = length(concat(azuread_service_principal_password.main[*].id, azuread_application_password.main[*].id)) == 1
    error_message = "By default, the module must create exactly one password."
  }

  assert {
    condition     = one(azuread_service_principal_password.main[*].id) != null
    error_message = "By default, the password must belong to the Service Principal."
  }

  assert {
    condition     = time_static.main != null
    error_message = "By default, the password end date must rely on `time_static.main`."
  }

  assert {
    condition     = output.secret_key == azuread_service_principal_password.main.value
    error_message = "Output `secret_key` must return the Service Principal password."
  }

  assert {
    condition     = output.validity_end_date == azuread_service_principal_password.main.end_date
    error_message = "Output `validity_end_date` must return the Service Principal password end date."
  }
}

run "application_token_creates_one_application_password" {
  variables {
    is_application_token = true
  }

  assert {
    condition     = length(concat(azuread_service_principal_password.main[*].id, azuread_application_password.main[*].id)) == 1
    error_message = "With `is_application_token`, the module must create exactly one password."
  }

  assert {
    condition     = one(azuread_application_password.main[*].id) != null
    error_message = "With `is_application_token`, the password must belong to the App Registration."
  }

  assert {
    condition     = output.secret_key == azuread_application_password.main.value
    error_message = "Output `secret_key` must return the App Registration password."
  }

  assert {
    condition     = output.validity_end_date == azuread_application_password.main.end_date
    error_message = "Output `validity_end_date` must return the App Registration password end date."
  }
}

run "token_disabled_creates_oidc_only_identity" {
  variables {
    token_enabled = false
    federated_identity_credentials = {
      gitlab-ci-main = {
        display_name = "gitlab-ci-main-pipeline"
        issuer       = "https://gitlab.com"
        subject      = "project_path:my-group/my-project:ref_type:branch:ref:main"
      }
    }
  }

  assert {
    condition     = azuread_service_principal_password.main == null && azuread_application_password.main == null
    error_message = "With `token_enabled = false`, the module must not create any password."
  }

  assert {
    condition     = time_static.main == null
    error_message = "With `token_enabled = false`, the module must not create `time_static.main`."
  }

  assert {
    condition     = output.secret_key == null && output.validity_end_date == null
    error_message = "With `token_enabled = false`, outputs `secret_key` and `validity_end_date` must be null."
  }

  assert {
    condition     = length(azuread_application_federated_identity_credential.main) == 1
    error_message = "With `token_enabled = false`, the federated identity credential must still be created."
  }
}

run "token_disabled_ignores_token_settings" {
  command = plan

  variables {
    token_enabled           = false
    is_application_token    = true
    token_validity_duration = null
    token_validity_end_date = null
  }

  assert {
    condition     = azuread_service_principal_password.main == null && azuread_application_password.main == null
    error_message = "With `token_enabled = false`, the module must not create any password, whatever `is_application_token`."
  }

  assert {
    condition     = output.secret_key == null && output.validity_end_date == null
    error_message = "With `token_enabled = false`, outputs `secret_key` and `validity_end_date` must be null."
  }
}

run "token_enabled_still_requires_a_validity" {
  command = plan

  variables {
    token_validity_duration = null
    token_validity_end_date = null
  }

  expect_failures = [
    azuread_service_principal_password.main,
  ]
}

run "application_token_still_requires_a_validity" {
  command = plan

  variables {
    is_application_token    = true
    token_validity_duration = null
    token_validity_end_date = null
  }

  expect_failures = [
    azuread_application_password.main,
  ]
}
