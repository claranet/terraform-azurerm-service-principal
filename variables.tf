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

variable "sp_scope_assignment" {
  description = "List of object representing the scopes and roles to assign the Service Principal with."
  type = list(object({
    scope     = string
    role_name = optional(string, "Reader")
    role_id   = optional(string)

    delegated_managed_identity_resource_id = optional(string)
    skip_service_principal_aad_check       = optional(bool, false)
  }))
  default = []
}

variable "sp_groups_member" {
  description = "Map of AAD Groups (group name => object ID) to add this Service Principal."
  type        = map(string)
  default     = {}
}
