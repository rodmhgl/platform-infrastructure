output "resource_group_name" {
  description = "Name of the Azure resource group"
  value       = azurerm_resource_group.main.name
}

output "resource_group_id" {
  description = "ID of the Azure resource group"
  value       = azurerm_resource_group.main.id
}

output "cluster_name" {
  description = "Name of the AKS cluster"
  value       = azurerm_kubernetes_cluster.main.name
}

output "cluster_id" {
  description = "Resource ID of the AKS cluster"
  value       = azurerm_kubernetes_cluster.main.id
}

output "cluster_fqdn" {
  description = "FQDN of the AKS cluster"
  value       = azurerm_kubernetes_cluster.main.fqdn
}

output "oidc_issuer_url" {
  description = "OIDC issuer URL for workload identity"
  value       = azurerm_kubernetes_cluster.main.oidc_issuer_url
}

output "kube_config_command" {
  description = "Command to configure kubectl"
  value       = "az aks get-credentials --resource-group ${azurerm_resource_group.main.name} --name ${azurerm_kubernetes_cluster.main.name}"
}

output "kube_config_raw" {
  description = "Raw kubeconfig for the cluster"
  sensitive   = true
  value       = azurerm_kubernetes_cluster.main.kube_config_raw
}

output "crossplane_identity_client_id" {
  description = "Client ID for Crossplane managed identity"
  value       = azurerm_user_assigned_identity.crossplane.client_id
}

output "crossplane_identity_principal_id" {
  description = "Principal ID for Crossplane managed identity"
  value       = azurerm_user_assigned_identity.crossplane.principal_id
}

output "subscription_id" {
  description = "Azure subscription ID"
  sensitive   = true
  value       = data.azurerm_client_config.current.subscription_id
}

output "tenant_id" {
  description = "Azure tenant ID"
  sensitive   = true
  value       = data.azurerm_client_config.current.tenant_id
}
