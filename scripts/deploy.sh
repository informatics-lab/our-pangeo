#!/bin/bash
set -e
echo "*** Deploy ***"

ENV=$1 # environment `dev` or `prod`
RELEASE_NAME=$2 # helm chart release name.
NAMESPACE=$3 # kubernetes namespace to use.

echo ENV=$1 RELEASE_NAME=$2

# if azure conect to  that cluster. This isn't the most elegent way/place of doing this. TODO: find a better way.
if [[ $ENV =~ "panzure" ]]
then
    echo "Azure env detected. Switching cluster"
    az login --service-principal --username ${AZ_USERNAME} --password ${AZ_PASSWORD} --tenant ${AZ_TENENT}
    az aks get-credentials -g "$ENV" -n "$ENV" --overwrite-existing
fi


# init helm
helm init


# Add upstream pangeo repo and update
helm repo add pangeo https://pangeo-data.github.io/helm-chart/
helm repo update

# Get deps
helm dependency update jadepangeo

# Apply changes
helm upgrade --install $RELEASE_NAME jadepangeo --namespace $NAMESPACE -f env/$ENV/values.yaml -f env/$ENV/secrets.yaml


echo "*** Deployed successfully ***"
