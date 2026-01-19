#!/bin/bash
# platform-infrastructure/scripts/bootstrap.sh
# Bootstrap script to install Argo CD and configure the App of Apps
#
# Usage: ./bootstrap.sh [environment]
#   environment: dev (default), prod, or any configured environment

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

log_info() { echo -e "${GREEN}[INFO]${NC} $1"; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

# -----------------------------------------------------------------------------
# Configuration - Update these for your environment
# -----------------------------------------------------------------------------

ENVIRONMENT="${1:-dev}"
GITHUB_ORG="${GITHUB_ORG:-your-github-org}"
GITOPS_REPO="${GITOPS_REPO:-platform-gitops}"
GITOPS_BRANCH="${GITOPS_BRANCH:-main}"

# Determine script directory and environment path
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ENV_DIR="${SCRIPT_DIR}/../environments/${ENVIRONMENT}"

if [[ ! -d "$ENV_DIR" ]]; then
    log_error "Environment directory not found: ${ENV_DIR}"
    log_error "Available environments: $(ls -1 "${SCRIPT_DIR}/../environments/" 2>/dev/null | tr '\n' ' ')"
    exit 1
fi

log_info "Deploying to environment: ${ENVIRONMENT}"

# -----------------------------------------------------------------------------
# Pre-flight checks
# -----------------------------------------------------------------------------

log_info "Running pre-flight checks..."

if ! command -v kubectl &> /dev/null; then
    log_error "kubectl is not installed"
    exit 1
fi

if ! command -v helm &> /dev/null; then
    log_error "helm is not installed"
    exit 1
fi

if ! kubectl cluster-info &> /dev/null; then
    log_error "Cannot connect to Kubernetes cluster. Run: az aks get-credentials ..."
    exit 1
fi

log_info "Pre-flight checks passed"

# -----------------------------------------------------------------------------
# Install Argo CD
# -----------------------------------------------------------------------------

log_info "Installing Argo CD..."

# # Create namespace
# kubectl create namespace argocd --dry-run=client -o yaml | kubectl apply -f -

# # Add Argo CD Helm repo
# helm repo add argo https://argoproj.github.io/argo-helm
# helm repo update

# # Install Argo CD
# helm upgrade --install argocd argo/argo-cd \
#     --namespace argocd \
#     --version 5.55.0 \
#     --set server.service.type=LoadBalancer \
#     --set configs.params."server\.insecure"=true \
#     --set server.extraArgs="{--insecure}" \
#     --wait \
#     --timeout 10m

# Using SSA to avoid ApplicationSet CRD size limits (>262KB annotation limit).
# --force-conflicts takes ownership of previously managed fields during upgrade.
# Note: Custom mods to manifest-defined fields will be overwritten.
# Path relative to repository root
GITOPS_PATH="${SCRIPT_DIR}/../../platform-gitops/argocd/install/"
kubectl apply --server-side --force-conflicts -k "$GITOPS_PATH"

log_info "Waiting for Argo CD to be ready..."
kubectl wait --for=condition=available --timeout=300s deployment/argocd-server -n argocd

# -----------------------------------------------------------------------------
# Get Argo CD credentials
# -----------------------------------------------------------------------------

log_info "Retrieving Argo CD admin password..."

ARGOCD_PASSWORD=$(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d)

# Wait for LoadBalancer IP
log_info "Waiting for Argo CD LoadBalancer IP..."
while true; do
    ARGOCD_IP=$(kubectl get svc argocd-server -n argocd -o jsonpath='{.status.loadBalancer.ingress[0].ip}' 2>/dev/null || echo "")
    if [ -n "$ARGOCD_IP" ]; then
        break
    fi
    sleep 5
done

# -----------------------------------------------------------------------------
# Create App of Apps
# -----------------------------------------------------------------------------

log_info "Creating App of Apps..."

cat <<EOF | kubectl apply -f -
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: platform-apps
  namespace: argocd
  finalizers:
    - resources-finalizer.argocd.argoproj.io
spec:
  project: default
  source:
    repoURL: git@github.com:${GITHUB_ORG}/${GITOPS_REPO}.git
    targetRevision: ${GITOPS_BRANCH}
    path: apps
  destination:
    server: https://kubernetes.default.svc
    namespace: argocd
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
    syncOptions:
      - CreateNamespace=true
      - PrunePropagationPolicy=foreground
EOF

# -----------------------------------------------------------------------------
# Output
# -----------------------------------------------------------------------------

echo ""
echo "=============================================="
log_info "Argo CD Installation Complete!"
echo "=============================================="
echo ""
echo "Argo CD URL: http://${ARGOCD_IP}"
echo "Username: admin"
echo "Password: ${ARGOCD_PASSWORD}"
echo ""
echo "Next steps:"
echo "1. Create the '${GITOPS_REPO}' repository in GitHub org '${GITHUB_ORG}'"
echo "2. Push the platform-gitops contents to that repo"
echo "3. Argo CD will automatically sync and deploy all platform components"
echo ""
log_warn "For production: Configure Ingress with TLS, SSO, and RBAC"
echo ""
