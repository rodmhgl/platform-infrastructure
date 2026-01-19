module "aks_crossplane" {
  source = "../../modules/aks-crossplane"

  cluster_name_prefix = var.cluster_name_prefix
  environment         = "prod"
  kubernetes_version  = var.kubernetes_version
  location            = var.location

  default_node_pool = {
    node_count      = 3
    os_disk_size_gb = 256
    vm_size         = "Standard_D4s_v3"
  }

  sku_tier = "Standard"

  tags = {
    cost_center = "production"
  }
}
