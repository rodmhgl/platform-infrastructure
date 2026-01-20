data "azurerm_client_config" "current" {}

locals {
  cluster_name = "${var.cluster_name_prefix}-${var.environment}"

  default_tags = {
    environment = var.environment
    managed_by  = "terraform"
    project     = "back-stack"
  }

  merged_tags = merge(local.default_tags, var.tags)
}

resource "azurerm_resource_group" "main" {
  location = var.location
  name     = "rg-${local.cluster_name}"
  tags     = local.merged_tags
}

resource "azurerm_user_assigned_identity" "aks" {
  location            = azurerm_resource_group.main.location
  name                = "id-${local.cluster_name}"
  resource_group_name = azurerm_resource_group.main.name
}

resource "azurerm_kubernetes_cluster" "main" {
  dns_prefix          = local.cluster_name
  kubernetes_version  = var.kubernetes_version
  location            = azurerm_resource_group.main.location
  name                = local.cluster_name
  resource_group_name = azurerm_resource_group.main.name
  sku_tier            = var.sku_tier

  azure_active_directory_role_based_access_control {
    azure_rbac_enabled = true
    tenant_id          = data.azurerm_client_config.current.tenant_id
  }

  default_node_pool {
    max_pods        = var.default_node_pool.max_pods
    name            = "system"
    node_count      = var.default_node_pool.node_count
    os_disk_size_gb = var.default_node_pool.os_disk_size_gb
    os_disk_type    = var.default_node_pool.os_disk_type
    vm_size         = var.default_node_pool.vm_size

    upgrade_settings {
      max_surge = var.default_node_pool.max_surge
    }
  }

  identity {
    identity_ids = [azurerm_user_assigned_identity.aks.id]
    type         = "UserAssigned"
  }

  network_profile {
    # TODO: Update for Cilium
    dns_service_ip    = var.network_profile.dns_service_ip
    load_balancer_sku = var.network_profile.load_balancer_sku
    network_plugin    = var.network_profile.network_plugin
    network_policy    = var.network_profile.network_policy
    service_cidr      = var.network_profile.service_cidr
  }

  oidc_issuer_enabled       = true
  workload_identity_enabled = true

  tags = local.merged_tags
}
