# Our Pangeo

We have joined forces with the [Pangeo community](https://pangeo-data.github.io/)! Pangeo is a curated stack of software and tools to empower big data processing in the atmostpheric, oceanographic and climate community. Much of the work we did in our previous [Jade](https://github.com/informatics-lab?utf8=%E2%9C%93&q=jade&type=&language=) project has been integreated into Pangeo.

This repository contains a [helm chart](https://github.com/kubernetes/helm/blob/master/docs/charts.md) which allows you to stand up our custom version of the Pangeo stack. This chart is mainly going to be a wrapper the [Pangeo chart](https://zero-to-jupyterhub.readthedocs.io/en/latest/) along with config to add our custom stuff.

## Usage

First off you need [helm](https://github.com/kubernetes/helm) if you don't have it already.

You'll also need to symlink the config from our [private-config](https://github.com/met-office-lab/private-config) repo.

_If you're not a member of the Informatics Lab and are looking to set this up yourself then check out the `values.yaml` file and the config for the other dependencies._

```shell
ln -s /path/to/private-config/jade-pangeo/secrets.yaml secrets.yaml
```

Now you can go ahead and run helm.

```shell
# Get deps
helm dependency update jadepangeo

# Install
helm install jadepangeo --name=jupyterhub.informaticslab.co.uk --namespace=jupyter -f values.yaml -f secrets.yaml

# Apply changes
helm upgrade jupyterhub.informaticslab.co.uk jadepangeo -f values.yaml -f secrets.yaml

# Delete
helm delete jupyterhub.informaticslab.co.uk --purge
```
