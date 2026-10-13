#!/bin/bash
# ============================================================================
# TAK Server Docker Image Build Script
# ============================================================================
# This script builds and pushes the TAK Server Docker image to SWR.
# ============================================================================

set -e

# Configuration
TAK_VERSION="${TAK_VERSION:-5.4.0}"
REGISTRY="${REGISTRY:-swr.cn-north-4.myhuaweicloud.com}"
PROJECT="${PROJECT:-tak}"
IMAGE_NAME="${IMAGE_NAME:-tak-server}"
IMAGE_TAG="${IMAGE_TAG:-${TAK_VERSION}}"
FULL_IMAGE="${REGISTRY}/${PROJECT}/${IMAGE_NAME}:${IMAGE_TAG}"

# Build the image
echo "Building TAK Server image: ${FULL_IMAGE}"
docker build -t ${FULL_IMAGE} -f src/Dockerfile .

echo "Image built successfully: ${FULL_IMAGE}"
echo ""
echo "To push to SWR:"
echo "  docker push ${FULL_IMAGE}"
echo ""
echo "To deploy to CCE:"
echo "  kubectl apply -f src/deployment.yaml"
