## 7.4.0 (2024-05-17)


### Features

* **AZ-1407:** change `sp_required_resource_access` variable type to fix the possibility to add several API permissions on the same API eb5abf6


### Continuous Integration

* **AZ-1391:** enable semantic-release [skip ci] 5a2888f
* **AZ-1391:** update semantic-release config [skip ci] 807e533


### Miscellaneous Chores

* **deps:** enable automerge on renovate ebd62c0
* **deps:** update dependency opentofu to v1.7.0 72ddc19
* **deps:** update dependency opentofu to v1.7.1 aae3879
* **deps:** update dependency pre-commit to v3.7.1 e10f740
* **deps:** update dependency tflint to v0.51.0 111eeb0
* **deps:** update dependency tflint to v0.51.1 d15fa01
* **deps:** update dependency trivy to v0.50.2 823fdc6
* **deps:** update dependency trivy to v0.50.4 cc0b478
* **deps:** update dependency trivy to v0.51.0 99d4ea8
* **deps:** update dependency trivy to v0.51.1 299c84a
* **deps:** update renovate.json 699b95e
* **pre-commit:** update commitlint hook 21321c9
* **release:** remove legacy `VERSION` file 5b2be77

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
