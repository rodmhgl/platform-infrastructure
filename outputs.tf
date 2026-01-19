output "resource_group_name" {
  description = "The name of the Azure resource group"
  value       = azurerm_resource_group.main.name
}

output "cluster_name" {
  description = "The name of the Azure Kubernetes Service (AKS) cluster"
  value       = azurerm_kubernetes_cluster.main.name
}

output "cluster_fqdn" {
  description = "The fully qualified domain name (FQDN) of the Azure Kubernetes Service (AKS) cluster"
  value       = azurerm_kubernetes_cluster.main.fqdn
}

output "oidc_issuer_url" {
  description = "The OpenID Connect (OIDC) issuer URL for the Azure Kubernetes Service (AKS) cluster"
  value       = azurerm_kubernetes_cluster.main.oidc_issuer_url
}

output "crossplane_identity_client_id" {
  description = "Client ID for the Crossplane user-assigned managed identity"
  value       = azurerm_user_assigned_identity.crossplane.client_id
}

output "subscription_id" {
  description = "The subscription ID of the Azure account"
  sensitive   = true
  value       = data.azurerm_client_config.current.subscription_id
}

output "tenant_id" {
  description = "The tenant ID of the Azure account"
  sensitive   = true
  value       = data.azurerm_client_config.current.tenant_id
}

output "kube_config_command" {
  description = "The command to configure kubectl to connect to the AKS cluster"
  value       = "az aks get-credentials --resource-group ${azurerm_resource_group.main.name} --name ${azurerm_kubernetes_cluster.main.name}"
}
