#!/bin/bash
# ============================================================================
# TAK Server Bootstrap Script for CCE Deployment
# ============================================================================
# This script deploys TAK Server to a CCE cluster.
# Prerequisites:
#   - kubectl installed and configured
#   - CCE cluster created with terraform
#   - Docker image pushed to SWR
# ============================================================================

set -e

# Configuration
NAMESPACE="${NAMESPACE:-tak}"
CCE_CLUSTER_NAME="${CCE_CLUSTER_NAME:-tak-server-cluster}"
IMAGE="${IMAGE:-swr.cn-north-4.myhuaweicloud.com/tak/tak-server:5.4.0}"

echo "=== TAK Server CCE Bootstrap ==="
echo "Namespace: ${NAMESPACE}"
echo "Image: ${IMAGE}"
echo ""

# Get cluster credentials
echo "Getting cluster credentials..."
huaweicloud cce cluster config ${CCE_CLUSTER_NAME} --export-kubeconfig ~/.kube/config-tak

# Merge credentials
KUBECONFIG=~/.kube/config-tak kubectl config view --merge --flatten > ~/.kube/config-tak-merged
mv ~/.kube/config-tak-merged ~/.kube/config-tak

# Set kubectl context
export KUBECONFIG=~/.kube/config-tak

# Create namespace
echo "Creating namespace..."
kubectl create namespace ${NAMESPACE} --dry-run=client -o yaml | kubectl apply -f -

# Update deployment image
echo "Updating deployment image..."
sed -i "s|image: tak-server:5.4.0|image: ${IMAGE}|g" src/deployment.yaml

# Deploy TAK Server
echo "Deploying TAK Server..."
kubectl apply -f src/deployment.yaml

# Wait for deployment
echo "Waiting for deployment to be ready..."
kubectl wait --for=condition=available --timeout=600s deployment/tak-server -n ${NAMESPACE}

# Show status
echo ""
echo "=== Deployment Status ==="
kubectl get pods -n ${NAMESPACE}
kubectl get svc -n ${NAMESPACE}

echo ""
echo "=== TAK Server deployed successfully! ==="
echo "Access TAK Server at:"
echo "  HTTP:  http://<ELB-IP>:8089"
echo "  HTTPS: https://<ELB-IP>:8443"
