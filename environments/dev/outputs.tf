output "resource_group_name" {
  description = "Name of the Azure resource group"
  value       = module.aks_crossplane.resource_group_name
}

output "cluster_name" {
  description = "Name of the AKS cluster"
  value       = module.aks_crossplane.cluster_name
}

output "cluster_fqdn" {
  description = "FQDN of the AKS cluster"
  value       = module.aks_crossplane.cluster_fqdn
}

output "oidc_issuer_url" {
  description = "OIDC issuer URL for workload identity"
  value       = module.aks_crossplane.oidc_issuer_url
}

output "crossplane_identity_client_id" {
  description = "Client ID for Crossplane managed identity"
  value       = module.aks_crossplane.crossplane_identity_client_id
}

output "subscription_id" {
  description = "Azure subscription ID"
  sensitive   = true
  value       = module.aks_crossplane.subscription_id
}

output "tenant_id" {
  description = "Azure tenant ID"
  sensitive   = true
  value       = module.aks_crossplane.tenant_id
}

output "kube_config_command" {
  description = "Command to configure kubectl"
  value       = module.aks_crossplane.kube_config_command
}
