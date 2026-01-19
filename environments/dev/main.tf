module "aks_crossplane" {
  source = "../../modules/aks-crossplane"

  cluster_name_prefix = var.cluster_name_prefix
  environment         = "dev"
  kubernetes_version  = var.kubernetes_version
  location            = var.location

  default_node_pool = {
    node_count = 2
    vm_size    = "Standard_D2s_v3"
  }

  sku_tier = "Free"

  tags = {
    cost_center = "development"
  }
}
