#!/bin/bash

# remove charts
rm -rf paperless-ngx/charts

# move tarballs out of docs directory
mv paperless-ngx/docs/*.tgz tmp/

# outside of helm chart directory
helm package paperless-ngx

# move newly created package file to docs
mv paperless-ngx-*.tgz paperless-ngx/docs/
mv tmp/*.tgz paperless-ngx/docs/

cd paperless-ngx
helm repo index docs --url https://wreiner.github.io/paperless-ngx-helm

# cat docs/index.yaml

git add docs/* Chart.yaml
gic -m "Create new helm chart release" docs/
git push
