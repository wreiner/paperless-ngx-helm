#!/bin/bash
set -e  # Exit on error
set -u  # Exit on undefined variable
set -o pipefail  # Exit on pipe failure

# Script to release a new Helm chart version
# Usage: ./scripts/release-chart.sh <chart_version> <app_version> [redis_version]

CHART_VERSION="${1:?Chart version required}"
APP_VERSION="${2:?App version required}"
REDIS_VERSION="${3:-}"

CHART_DIR="paperless-ngx"
DOCS_DIR="docs"
GITHUB_PAGES_URL="https://wreiner.github.io/paperless-ngx-helm"

echo "==> Releasing Helm chart"
echo "    Chart version: ${CHART_VERSION}"
echo "    App version: ${APP_VERSION}"
[ -n "${REDIS_VERSION}" ] && echo "    Redis version: ${REDIS_VERSION}"
echo ""

# Check if yq is available
if ! command -v yq &> /dev/null; then
    echo "ERROR: yq is not installed. Please install it first."
    exit 1
fi

# Check if helm is available
if ! command -v helm &> /dev/null; then
    echo "ERROR: helm is not installed. Please install it first."
    exit 1
fi

# Update Chart.yaml
echo "==> Updating Chart.yaml"
cd "${CHART_DIR}"
yq -i ".version = \"${CHART_VERSION}\"" Chart.yaml
yq -i ".appVersion = \"${APP_VERSION}\"" Chart.yaml

if [ -n "${REDIS_VERSION}" ]; then
    echo "    Updating Redis dependency to ${REDIS_VERSION}"
    yq -i "(.dependencies[] | select(.name == \"redis\")).version = \"${REDIS_VERSION}\"" Chart.yaml
fi

# Update dependencies
echo "==> Updating Helm dependencies"
helm dependency update

cd ..

# Package chart
echo "==> Packaging chart"
helm package "${CHART_DIR}" -d "${DOCS_DIR}/"

# Update repo index
echo "==> Updating Helm repository index"
helm repo index "${DOCS_DIR}" --url "${GITHUB_PAGES_URL}"

echo ""
echo "==> New release built successfully!"
echo "    Package: ${DOCS_DIR}/paperless-ngx-${CHART_VERSION}.tgz"
echo ""
echo "Changed files:"
git status --short
