# Resource group
output "resource_group_name" {
  description = "Name of the Azure resource group"
  value       = module.aks_crossplane.resource_group_name
}

output "resource_group_id" {
  description = "ID of the Azure resource group"
  value       = module.aks_crossplane.resource_group_id
}

# AKS cluster
output "cluster_name" {
  description = "Name of the AKS cluster"
  value       = module.aks_crossplane.cluster_name
}

output "cluster_id" {
  description = "Resource ID of the AKS cluster"
  value       = module.aks_crossplane.cluster_id
}

output "cluster_fqdn" {
  description = "FQDN of the AKS cluster"
  value       = module.aks_crossplane.cluster_fqdn
}

output "oidc_issuer_url" {
  description = "OIDC issuer URL for workload identity"
  value       = module.aks_crossplane.oidc_issuer_url
}

output "kube_config_command" {
  description = "Command to configure kubectl"
  value       = module.aks_crossplane.kube_config_command
}

output "kube_config_raw" {
  description = "Raw kubeconfig for the cluster"
  sensitive   = true
  value       = module.aks_crossplane.kube_config_raw
}

# Crossplane identity
output "crossplane_identity_client_id" {
  description = "Client ID for Crossplane managed identity"
  value       = module.aks_crossplane.crossplane_identity_client_id
}

output "crossplane_identity_principal_id" {
  description = "Principal ID for Crossplane managed identity"
  value       = module.aks_crossplane.crossplane_identity_principal_id
}

# Azure context
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
