output "workspace_ids" {
  description = "Map of environment names to workspace IDs"
  value       = { for k, v in tfe_workspace.env : k => v.id }
}

output "workspace_urls" {
  description = "URLs to the TFC workspaces"
  value = {
    for k, v in tfe_workspace.env : k => "https://app.terraform.io/app/${var.tfc_organization}/workspaces/${v.name}"
  }
}

output "variable_set_ids" {
  description = "Map of variable set names to IDs"
  value = merge(
    { azure_auth = tfe_variable_set.azure_auth.id },
    { for k, v in tfe_variable_set.env : "${k}_vars" => v.id }
  )
}