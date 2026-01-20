module "aks_crossplane" {
  source = "./modules/aks-crossplane"

  cluster_name_prefix = var.cluster_name_prefix
  environment         = var.environment
  kubernetes_version  = var.kubernetes_version
  location            = var.location

  default_node_pool = var.default_node_pool
  network_profile   = var.network_profile
  sku_tier          = var.sku_tier

  crossplane_namespace       = var.crossplane_namespace
  crossplane_service_account = var.crossplane_service_account

  tags = var.tags
}