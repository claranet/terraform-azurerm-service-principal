# v7.3.1 - 2024-03-15

Fixed
 * [GH-1](https://github.com/claranet/terraform-azurerm-service-principal/pull/1): fix also `azuread_service_principal` resource with `client_id` attribute instead of deprecated `application_id`

# v7.3.0 - 2023-11-17

Changed
  * [GH-1](https://github.com/claranet/terraform-azurerm-service-principal/pull/1): `azuread_application` attribute `application_id` has been deprecated.

# v7.2.1 - 2023-08-18

Fixed
  * AZ-1124: Fixes

# v7.2.0 - 2023-08-18

Added
  * AZ-1124: Add API and web settings

# v7.1.0 - 2023-06-09

Added
  * AZ-1095: Add `required_resource_access` option for OAuth configuration

# v7.0.2 - 2022-12-12

Fixed
  * AZ-941: Fix SP role output

# v7.0.1 - 2022-11-10

Fixed
  * AZ-902: Fix SP role implementation

# v7.0.0 - 2022-10-12

Added
  * AZ-854: Module Azure Service Principal
