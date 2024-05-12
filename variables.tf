variable "sp_aad_app_tags" {
  description = "A set of tags to apply to the application. Tag values also propagate to any linked service principals."
  type        = list(string)
  default     = []
}

variable "sp_owners" {
  description = "A set of object IDs of principals that will be granted ownership of both the AAD Application and associated Service Principal. Supported object types are users or service principals."
  type        = list(string)
  default     = []
}

variable "sp_token_validity_duration" {
  description = "Azure Service Principal token/password duration before it expires. Defaults to 2 years. Notation documentation: https://pkg.go.dev/time#ParseDuration"
  type        = string
  default     = "${24 * 365 * 2}h" # 2 years
}

variable "identifier_uris" {
  description = "A set of user-defined URI(s) that uniquely identify an application within its Azure AD tenant, or within a verified custom domain if the application is multi-tenant."
  type        = list(string)
  default     = []
}

variable "sp_scope_assignment" {
  description = "List of object representing the scopes and roles to assign the Service Principal with."
  type = list(object({
    scope     = string
    role_name = optional(string)
    role_id   = optional(string)

    delegated_managed_identity_resource_id = optional(string)
    skip_service_principal_aad_check       = optional(bool, false)
  }))
  default = []
  validation {
    condition     = alltrue([for s in var.sp_scope_assignment : s.role_name != null || s.role_id != null])
    error_message = "`role_name` or `role_id` attribute must be set."
  }
}

variable "sp_groups_member" {
  description = "Map of AAD Groups (group name => object ID) to add this Service Principal."
  type        = map(string)
  default     = {}
}

variable "sp_required_resource_access" {
  description = "List of Service Principal Application OAuth permission scopes configuration. https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/application#resource_access"
  type = map(list(object({
    resource_access_id   = string
    resource_access_type = string
  })))
  default  = {}
  nullable = false
}

variable "api_settings" {
  description = "Settings for the APIs you need to define using this Service Principal."
  type = object({
    known_client_applications      = optional(list(string), [])
    mapped_claims_enabled          = optional(bool, false)
    requested_access_token_version = optional(number, 1)
    oauth2_permission_scopes = optional(list(object({
      admin_consent_description  = string
      admin_consent_display_name = string
      enabled                    = optional(bool, true)
      id                         = optional(string)
      type                       = optional(string, "User")
      user_consent_description   = optional(string)
      user_consent_display_name  = optional(string)
      value                      = optional(string)
    })), [])
  })
  default  = {}
  nullable = false
}

variable "web_settings" {
  description = "Configuration for web related settings for this Service Principal."
  type = object({
    homepage_url                  = optional(string, null)
    logout_url                    = optional(string, null)
    redirect_uris                 = optional(list(string), [])
    access_token_issuance_enabled = optional(bool)
    id_token_issuance_enabled     = optional(bool)
  })
  default  = {}
  nullable = false
}
