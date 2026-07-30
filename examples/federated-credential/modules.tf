module "sp" {
  source  = "claranet/service-principal/azurerm"
  version = "x.x.x"

  display_name = "claranet-tools"
  owners       = data.azuread_users.owners.object_ids

  scope_assignment = [
    {
      scope     = data.azurerm_subscription.main.id
      role_name = null
      role_id   = azurerm_role_definition.example.role_definition_resource_id
    },
    {
      scope     = data.azurerm_resource_group.main.id
      role_name = "Contributor"
    }
  ]

  groups_member = {
    (data.azuread_group.readers.display_name) = data.azuread_group.readers.object_id
  }

  entra_app_tags = ["foo", "bar"]

  # az ad sp list --display-name "Microsoft Graph" --query '[].{appDisplayName:appDisplayName, appId:appId}'
  required_resource_access = {
    # Azure Healthcare APIs
    "4f6778d8-5aef-43dc-a1ff-b073724b9495" = [{
      resource_access_id   = "4f6778d8-5aef-43dc-a1ff-b073724b9495" # user_impersonation - Application
      resource_access_type = "Role"
    }]
    # Microsoft.Graph
    "00000003-0000-0000-c000-000000000000" = [{
      resource_access_id   = "e1fe6dd8-ba31-4d61-89e7-88639da4683d" # User.Read - Delegated
      resource_access_type = "Scope"
      },
      {
        resource_access_id   = "19dbc75e-c2e2-444c-a770-ec69d8559fc7" # Directory.ReadWrite.All - Delegated
        resource_access_type = "Scope"
      }
    ]
  }

  # Classic federated credentials — exact subject matching (GA)
  federated_identity_credentials = {
    github-actions-main = {
      display_name = "github-actions-main-branch"
      issuer       = "https://token.actions.githubusercontent.com"
      subject      = "repo:my-org/my-repo:ref:refs/heads/main"
    }
    gitlab-ci-main = {
      display_name = "gitlab-ci-main-pipeline"
      issuer       = "https://gitlab.com"
      subject      = "project_path:my-group/my-project:ref_type:branch:ref:main"
    }
    kubernetes-default = {
      display_name = "k8s-default-namespace"
      issuer       = "https://oidc.eks.eu-west-1.amazonaws.com/id/EXAMPLE"
      subject      = "system:serviceaccount:default:my-serviceaccount"
    }
  }

  # Flexible federated credentials — wildcard claims matching (preview)
  # federated_identity_credentials = {
  #   github-actions-any-branch = {
  #     display_name               = "github-actions-any-branch"
  #     issuer                     = "https://token.actions.githubusercontent.com"
  #     claims_matching_expression = "claims['sub'] matches 'repo:my-org/my-repo:ref:refs/heads/*'"
  #   }
  # }
}
