<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_federated_identity_credential.crossplane](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/federated_identity_credential) | resource |
| [azurerm_kubernetes_cluster.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/kubernetes_cluster) | resource |
| [azurerm_resource_group.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [azurerm_role_assignment.crossplane_contributor](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_user_assigned_identity.aks](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/user_assigned_identity) | resource |
| [azurerm_user_assigned_identity.crossplane](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/user_assigned_identity) | resource |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cluster_name_prefix"></a> [cluster\_name\_prefix](#input\_cluster\_name\_prefix) | Prefix for cluster naming. Full name: {prefix}-{environment} | `string` | `"back-stack-aks"` | no |
| <a name="input_crossplane_namespace"></a> [crossplane\_namespace](#input\_crossplane\_namespace) | Kubernetes namespace where Crossplane provider runs | `string` | `"crossplane-system"` | no |
| <a name="input_crossplane_service_account"></a> [crossplane\_service\_account](#input\_crossplane\_service\_account) | Service account name for Crossplane Azure provider | `string` | `"provider-azure"` | no |
| <a name="input_default_node_pool"></a> [default\_node\_pool](#input\_default\_node\_pool) | Configuration for the default (system) node pool | <pre>object({<br/>    node_count      = number<br/>    vm_size         = string<br/>    os_disk_size_gb = optional(number, 128)<br/>    os_disk_type    = optional(string, "Managed")<br/>    max_pods        = optional(number, 110)<br/>    max_surge       = optional(string, "33%")<br/>  })</pre> | <pre>{<br/>  "node_count": 3,<br/>  "vm_size": "Standard_D4s_v3"<br/>}</pre> | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment name (e.g., dev, prod). Used in resource naming. | `string` | n/a | yes |
| <a name="input_kubernetes_version"></a> [kubernetes\_version](#input\_kubernetes\_version) | Kubernetes version for the AKS cluster | `string` | `null` | no |
| <a name="input_location"></a> [location](#input\_location) | Azure region for all resources | `string` | n/a | yes |
| <a name="input_network_profile"></a> [network\_profile](#input\_network\_profile) | Network profile configuration for AKS | <pre>object({<br/>    network_plugin    = optional(string, "azure")<br/>    network_policy    = optional(string, "azure")<br/>    load_balancer_sku = optional(string, "standard")<br/>    service_cidr      = optional(string, "10.0.0.0/16")<br/>    dns_service_ip    = optional(string, "10.0.0.10")<br/>  })</pre> | `{}` | no |
| <a name="input_sku_tier"></a> [sku\_tier](#input\_sku\_tier) | AKS SKU tier: Free, Standard, or Premium | `string` | `"Free"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Additional tags for all resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cluster_fqdn"></a> [cluster\_fqdn](#output\_cluster\_fqdn) | FQDN of the AKS cluster |
| <a name="output_cluster_id"></a> [cluster\_id](#output\_cluster\_id) | Resource ID of the AKS cluster |
| <a name="output_cluster_name"></a> [cluster\_name](#output\_cluster\_name) | Name of the AKS cluster |
| <a name="output_crossplane_identity_client_id"></a> [crossplane\_identity\_client\_id](#output\_crossplane\_identity\_client\_id) | Client ID for Crossplane managed identity |
| <a name="output_crossplane_identity_principal_id"></a> [crossplane\_identity\_principal\_id](#output\_crossplane\_identity\_principal\_id) | Principal ID for Crossplane managed identity |
| <a name="output_kube_config_command"></a> [kube\_config\_command](#output\_kube\_config\_command) | Command to configure kubectl |
| <a name="output_kube_config_raw"></a> [kube\_config\_raw](#output\_kube\_config\_raw) | Raw kubeconfig for the cluster |
| <a name="output_oidc_issuer_url"></a> [oidc\_issuer\_url](#output\_oidc\_issuer\_url) | OIDC issuer URL for workload identity |
| <a name="output_resource_group_id"></a> [resource\_group\_id](#output\_resource\_group\_id) | ID of the Azure resource group |
| <a name="output_resource_group_name"></a> [resource\_group\_name](#output\_resource\_group\_name) | Name of the Azure resource group |
| <a name="output_subscription_id"></a> [subscription\_id](#output\_subscription\_id) | Azure subscription ID |
| <a name="output_tenant_id"></a> [tenant\_id](#output\_tenant\_id) | Azure tenant ID |
<!-- END_TF_DOCS -->