# Create new release of this helm chart

```
# outside of helm chart directory
helm package paperless-ngx

# move newly created package file to docs
mv paperless-ngx-*.tgz paperless-ngx/docs/

cd paperless-ngx
helm repo index docs --url https://wreiner.github.io/paperless-ngx-helm

cat docs/index.yaml

helm repo update
helm search repo pngxh/paperless-ngx --versions | head 3
```
