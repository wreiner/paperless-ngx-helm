# paperless-ngx-helm

A helm chart to install [paperless-ngx](https://github.com/paperless-ngx/paperless-ngx).

## Configuration

Configuration is done through values.yaml.

Most notably are the directives `env` and `extraSecretNamesForEnvFrom`.

### Directive `env`

Through `env` it is possible to set paperless-ngx environment variables.

A list of them can be found in the [paperless-ngx documentation](https://docs.paperless-ngx.com/configuration/).

### Directive `extraSecretNamesForEnvFrom`

To create the initial admin user and its password or the paperless-ngx secret
it is recommended to create a secret in the same namespace as paperless-ngx is
deployed in.
