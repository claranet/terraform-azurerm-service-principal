## 7.4.1 (2024-10-03)

### Documentation

* update README badge to use OpenTofu registry a5f151f
* update README with `terraform-docs` v0.19.0 3d719ee

### Miscellaneous Chores

* **deps:** update dependency opentofu to v1.7.2 b0f4cfb
* **deps:** update dependency opentofu to v1.7.3 2a15914
* **deps:** update dependency opentofu to v1.8.1 ce4e1a0
* **deps:** update dependency opentofu to v1.8.2 257214a
* **deps:** update dependency pre-commit to v3.8.0 131906f
* **deps:** update dependency terraform-docs to v0.18.0 c6b57ff
* **deps:** update dependency terraform-docs to v0.19.0 5398c36
* **deps:** update dependency tflint to v0.51.2 3f66a99
* **deps:** update dependency tflint to v0.52.0 d4faeab
* **deps:** update dependency tflint to v0.53.0 e99e99a
* **deps:** update dependency trivy to v0.51.2 c64393c
* **deps:** update dependency trivy to v0.51.4 0487ef0
* **deps:** update dependency trivy to v0.52.0 8e7fe64
* **deps:** update dependency trivy to v0.52.1 c41ec80
* **deps:** update dependency trivy to v0.52.2 d03aef5
* **deps:** update dependency trivy to v0.53.0 eabc9cb
* **deps:** update dependency trivy to v0.55.0 c7ffa08
* **deps:** update dependency trivy to v0.55.1 d7bf45e
* **deps:** update dependency trivy to v0.55.2 ca2b0bc
* **deps:** update pre-commit hook alessandrojcm/commitlint-pre-commit-hook to v9.17.0 e9ea9a1
* **deps:** update pre-commit hook alessandrojcm/commitlint-pre-commit-hook to v9.18.0 d5a23fc
* **deps:** update pre-commit hook antonbabenko/pre-commit-terraform to v1.92.0 183ff44
* **deps:** update pre-commit hook antonbabenko/pre-commit-terraform to v1.92.1 5b0738c
* **deps:** update pre-commit hook antonbabenko/pre-commit-terraform to v1.92.2 2b902ed
* **deps:** update pre-commit hook antonbabenko/pre-commit-terraform to v1.92.3 79ace54
* **deps:** update pre-commit hook antonbabenko/pre-commit-terraform to v1.93.0 43a1e37
* **deps:** update pre-commit hook antonbabenko/pre-commit-terraform to v1.94.0 6e6fc39
* **deps:** update pre-commit hook antonbabenko/pre-commit-terraform to v1.94.1 ee8fafb
* **deps:** update pre-commit hook antonbabenko/pre-commit-terraform to v1.94.2 b07b266
* **deps:** update pre-commit hook antonbabenko/pre-commit-terraform to v1.94.3 5ec4343
* **deps:** update pre-commit hook antonbabenko/pre-commit-terraform to v1.95.0 34de264
* **deps:** update pre-commit hook antonbabenko/pre-commit-terraform to v1.96.0 c2114a4
* **deps:** update pre-commit hook antonbabenko/pre-commit-terraform to v1.96.1 19292ed
* **deps:** update tools c22cd5a

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
