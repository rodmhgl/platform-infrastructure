<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.14.0 |
| <a name="requirement_tfe"></a> [tfe](#requirement\_tfe) | ~> 0.64 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_tfe"></a> [tfe](#provider\_tfe) | 0.73.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [tfe_run_trigger.prod_after_dev](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/run_trigger) | resource |
| [tfe_variable.arm_client_id](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/variable) | resource |
| [tfe_variable.arm_client_secret](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/variable) | resource |
| [tfe_variable.arm_subscription_id](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/variable) | resource |
| [tfe_variable.arm_tenant_id](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/variable) | resource |
| [tfe_variable.environment](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/variable) | resource |
| [tfe_variable.prevent_rg_deletion](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/variable) | resource |
| [tfe_variable.sku_tier](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/variable) | resource |
| [tfe_variable.subscription_id](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/variable) | resource |
| [tfe_variable_set.azure_auth](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/variable_set) | resource |
| [tfe_variable_set.env](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/variable_set) | resource |
| [tfe_workspace.env](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/workspace) | resource |
| [tfe_workspace_variable_set.azure_auth](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/workspace_variable_set) | resource |
| [tfe_workspace_variable_set.env](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/workspace_variable_set) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_arm_client_id"></a> [arm\_client\_id](#input\_arm\_client\_id) | Azure Service Principal Client ID | `string` | n/a | yes |
| <a name="input_arm_client_secret"></a> [arm\_client\_secret](#input\_arm\_client\_secret) | Azure Service Principal Client Secret | `string` | n/a | yes |
| <a name="input_arm_tenant_id"></a> [arm\_tenant\_id](#input\_arm\_tenant\_id) | Azure Tenant ID | `string` | n/a | yes |
| <a name="input_dev_subscription_id"></a> [dev\_subscription\_id](#input\_dev\_subscription\_id) | Azure Subscription ID for dev environment | `string` | n/a | yes |
| <a name="input_github_oauth_token_id"></a> [github\_oauth\_token\_id](#input\_github\_oauth\_token\_id) | OAuth token ID for GitHub VCS connection (find in TFC Organization Settings > VCS Providers) | `string` | n/a | yes |
| <a name="input_github_repository"></a> [github\_repository](#input\_github\_repository) | GitHub repository identifier (e.g., 'rodmhgl/platform-infrastructure') | `string` | `"rodmhgl/platform-infrastructure"` | no |
| <a name="input_prod_after_dev_trigger_enabled"></a> [prod\_after\_dev\_trigger\_enabled](#input\_prod\_after\_dev\_trigger\_enabled) | Enable promotion from dev to prod environment | `bool` | `true` | no |
| <a name="input_prod_subscription_id"></a> [prod\_subscription\_id](#input\_prod\_subscription\_id) | Azure Subscription ID for prod environment | `string` | n/a | yes |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | Project name prefix for workspaces | `string` | `"back-stack"` | no |
| <a name="input_tfc_organization"></a> [tfc\_organization](#input\_tfc\_organization) | Terraform Cloud organization name | `string` | n/a | yes |
| <a name="input_vcs_branch"></a> [vcs\_branch](#input\_vcs\_branch) | VCS branch to track | `string` | `"main"` | no |
| <a name="input_working_directory"></a> [working\_directory](#input\_working\_directory) | Working directory within the repository | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_variable_set_ids"></a> [variable\_set\_ids](#output\_variable\_set\_ids) | Map of variable set names to IDs |
| <a name="output_workspace_ids"></a> [workspace\_ids](#output\_workspace\_ids) | Map of environment names to workspace IDs |
| <a name="output_workspace_urls"></a> [workspace\_urls](#output\_workspace\_urls) | URLs to the TFC workspaces |
<!-- END_TF_DOCS -->