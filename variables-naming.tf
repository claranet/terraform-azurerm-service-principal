variable "display_name" {
  description = "Azure Service Principal (and AAD application) display name."
  type        = string
}

variable "token_display_name" {
  description = "A display name for the Service Principal's password."
  type        = string
  default     = "Terraform managed secret"
}
