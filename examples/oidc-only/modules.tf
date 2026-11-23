module "sp" {
  source  = "claranet/service-principal/azurerm"
  version = "x.x.x"

  display_name = "claranet-tools-oidc"

  scope_assignment = [
    {
      scope     = data.azurerm_subscription.main.id
      role_name = "Reader"
    },
    {
      scope     = data.azurerm_resource_group.main.id
      role_name = "Contributor"
    }
  ]

  # No client secret: the Service Principal only authenticates with the federated credentials below (OIDC),
  # so the `secret_key` and `validity_end_date` outputs are `null`.
  token_enabled = false

  federated_identity_credentials = {
    gitlab-ci-main = {
      display_name = "gitlab-ci-main-pipeline"
      issuer       = "https://gitlab.com"
      subject      = "project_path:my-group/my-project:ref_type:branch:ref:main"
    }
  }
}
