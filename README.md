# JupyterHub on Kubernetes

This is our deployment of the official [helm chart](https://github.com/kubernetes/helm/blob/master/docs/charts.md) for JupyterHub. See the [docs](https://zero-to-jupyterhub.readthedocs.io/en/latest/) for more info.

## Usage

First off you need [helm](https://github.com/kubernetes/helm) if you don't have it already.

You'll also need to symlink the config from our [private-config](https://github.com/met-office-lab/private-config) repo.

```shell
ln -s /path/to/private-config/jade-pangeo/values.yaml values.yaml
```

Now you can go ahead and run helm.

```shell
# Get deps
helm dependency update jadejupyter

# Install
helm install jadejupyter --version=v0.4 --name=jupyterhub.informaticslab.co.uk --namespace=jupyter -f values.yaml

# Apply changes
helm upgrade jupyterhub.informaticslab.co.uk jadejupyter -f values.yaml

# Delete
helm delete jupyterhub.informaticslab.co.uk --purge
```
