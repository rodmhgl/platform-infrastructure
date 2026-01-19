locals {
  crossplane_subject = "system:serviceaccount:${var.crossplane_namespace}:${var.crossplane_service_account}"
}

resource "azurerm_user_assigned_identity" "crossplane" {
  location            = azurerm_resource_group.main.location
  name                = "id-${local.cluster_name}-crossplane"
  resource_group_name = azurerm_resource_group.main.name
}

resource "azurerm_federated_identity_credential" "crossplane" {
  audience            = ["api://AzureADTokenExchange"]
  issuer              = azurerm_kubernetes_cluster.main.oidc_issuer_url
  name                = "crossplane-provider-azure-${var.environment}"
  parent_id           = azurerm_user_assigned_identity.crossplane.id
  resource_group_name = azurerm_resource_group.main.name
  subject             = local.crossplane_subject
}

# Grant Crossplane identity Contributor on the subscription
# TODO: Scope down in production!
resource "azurerm_role_assignment" "crossplane_contributor" {
  principal_id         = azurerm_user_assigned_identity.crossplane.principal_id
  role_definition_name = "Contributor"
  scope                = "/subscriptions/${data.azurerm_client_config.current.subscription_id}"
}
