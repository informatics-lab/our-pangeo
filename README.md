# Jade Pangeo

We have joined forces with the [Pangeo community](https://pangeo-data.github.io/)! Pangeo is a curated stack of software and tools to empower big data processing in the atmostpheric, oceanographic and climate community. This repository contains a [helm chart](https://github.com/kubernetes/helm/blob/master/docs/charts.md) which allows you to stand up the Jade flavour of the Pangeo stack.

This chart is mainly going to be a wrapper to subcharts such as [jupyterhub](https://zero-to-jupyterhub.readthedocs.io/en/latest/) along with config to tie them together.

## Usage

First off you need [helm](https://github.com/kubernetes/helm) if you don't have it already.

You'll also need to symlink the config from our [private-config](https://github.com/met-office-lab/private-config) repo.

_If you're not a member of the Informatics Lab and are looking to set this up yourself then check out the `values.yaml` file and the config for the other dependencies._

```shell
ln -s /path/to/private-config/jade-pangeo/values.yaml values.yaml
```

Now you can go ahead and run helm.

```shell
# Get deps
helm dependency update jadepangeo

# Install
helm install jadepangeo --name=pangeo.informaticslab.co.uk --namespace=jupyter -f values.yaml

# Apply changes
helm upgrade pangeo.informaticslab.co.uk jadepangeo -f values.yaml

# Delete
helm delete pangeo.informaticslab.co.uk --purge
```
