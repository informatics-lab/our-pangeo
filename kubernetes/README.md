# JupyterHub on Kubernetes

This is our deployment of the official [helm chart](https://github.com/kubernetes/helm/blob/master/docs/charts.md) for JupyterHub. See the [docs](https://zero-to-jupyterhub.readthedocs.io/en/latest/) for more info.

## Usage

First off you need [helm](https://github.com/kubernetes/helm) if you don't have it already.

The config file has been cleaned so that it can be pushed to GitHub. Therefore the first thing you need to do is make a copy of the config and populate some of the values.

```shell
cp example-helm-config.yaml helm-config.yaml
```

Generate some tokens to use a secrets.

```shell
openssl rand -hex 32
openssl rand -hex 32
```

Replace `COOKIE_SECRET` and `PROXY_SECRET` with the generated strings.

Create a new [GitHub oauth application](https://github.com/settings/applications/new) and replace the `GITHUB_CLIENT_ID` and `GITHUB_CLIENT_SECRET` with the provided tokens.

Now you can go ahead and run helm.

```shell
# Get deps
helm dependency update jadejupyter

# Install
helm install jadejupyter --version=v0.4 --name=jupyterhub.informaticslab.co.uk --namespace=jupyter -f kubernetes/helm-config.yaml

# Apply changes
helm upgrade jupyterhub.informaticslab.co.uk jadejupyter -f helm-config.yaml

# Delete
helm delete jupyterhub.informaticslab.co.uk --purge
```
