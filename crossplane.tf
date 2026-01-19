resource "azurerm_user_assigned_identity" "crossplane" {
  name                = "id-${var.cluster_name}-crossplane"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
}

# Federated Credential for Crossplane Workload Identity
resource "azurerm_federated_identity_credential" "crossplane" {
  name                = "crossplane-provider-azure"
  resource_group_name = azurerm_resource_group.main.name
  parent_id           = azurerm_user_assigned_identity.crossplane.id
  audience            = ["api://AzureADTokenExchange"]
  issuer              = azurerm_kubernetes_cluster.main.oidc_issuer_url
  subject             = "system:serviceaccount:crossplane-system:provider-azure"
}

# Grant Crossplane identity Contributor on the lab subscription
# TODO: Scope down in production!
resource "azurerm_role_assignment" "crossplane_contributor" {
  scope                = "/subscriptions/${data.azurerm_client_config.current.subscription_id}"
  role_definition_name = "Contributor"
  principal_id         = azurerm_user_assigned_identity.crossplane.principal_id
}
