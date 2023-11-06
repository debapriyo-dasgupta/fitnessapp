#!/bin/bash
# Load the utility functions
. pipeline/common.lib/utils/get-version.sh
kubectl config set-context --current --namespace=$2

echo "Configurations will be applied in the below namespace-----"
kubectl config view --minify | grep namespace:

# Deploy the environment specific configurations
cd licenses

kubectl apply -f .

#kubectl apply -f ../demo-multi-versions/

echo "Describing the configurations"
kubectl describe cm webmethodslicensekeys
