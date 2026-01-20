# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

Terraform configuration for provisioning AKS cluster with Crossplane workload identity. Part of the larger BACK Stack MVP - see `../CLAUDE.md` for overall architecture.

Designed for Terraform Cloud with multiple workspaces (dev, staging, prod) sharing a single configuration.

## File Structure

| File | Purpose |
|------|---------|
| `main.tf` | Root module calling aks-crossplane module |
| `variables.tf` | All configurable inputs including environment-specific settings |
| `outputs.tf` | Passthrough outputs from module |
| `providers.tf` | Azure provider config with parameterized settings |
| `modules/aks-crossplane/` | Reusable module: AKS, Crossplane identity, RBAC |
| `scripts/bootstrap.sh` | Post-terraform: installs Argo CD, creates App of Apps |

## Terraform Cloud Usage

Create workspaces pointing to this directory with environment-specific variable sets:

| Workspace | Key Variables |
|-----------|---------------|
| `back-stack-dev` | `environment=dev`, `sku_tier=Free`, `prevent_rg_deletion=false` |
| `back-stack-prod` | `environment=prod`, `sku_tier=Standard`, `prevent_rg_deletion=true` |

Required variables (set via workspace or variable set):
- `subscription_id` - Azure subscription (mark as sensitive)
- `environment` - Environment name used in resource naming

## Commands (Local Development)

```bash
terraform init
terraform plan -var="subscription_id=xxx" -var="environment=dev"
terraform apply
terraform output -json
```

Get kubeconfig after apply:
```bash
eval "$(terraform output -raw kube_config_command)"
```

Run bootstrap after cluster is ready:
```bash
source .env && ./scripts/bootstrap.sh
```

## Key Outputs

- `crossplane_identity_client_id` - Required for Crossplane Azure provider config
- `oidc_issuer_url` - Used by federated identity credential
- `kube_config_command` - Ready-to-run az aks get-credentials command

## Dependencies

Terraform outputs feed into:
1. `bootstrap.sh` - Uses kubeconfig to install Argo CD
2. `configure.sh` (parent dir) - Substitutes `${CROSSPLANE_CLIENT_ID}`, `${SUBSCRIPTION_ID}`, `${TENANT_ID}` in platform-gitops manifests

## Notes

- Crossplane identity has subscription-level Contributor (scope down for production)
- AKS uses workload identity (OIDC issuer enabled)
- `.env` file configures `GITHUB_ORG`, `GITOPS_REPO`, `GITOPS_BRANCH` for bootstrap
- Provider versions pinned in root module only; child module declares providers without versions
