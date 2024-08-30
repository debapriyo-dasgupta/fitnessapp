#!/bin/bash
# Load the utility functions
. infra/pipeline/common.lib/utils/get-version.sh

echo "Configurations will be applied in the below namespace-----"
kubectl config view --minify | grep namespace:

# Deploy the environment specific configurations
cd applications/memberships/app-manifests/

read VERSION IMAGE_NAME < <(get-version "../version.txt")
echo "IMAGE DETAILS - $IMAGE_NAME:$VERSION"

# Deploy the target manifests to create the runtimes/pods
sed -i "s/<TAG>/${VERSION}/g" memberships-deployment.yaml
sed -i "s|<IMAGE_NAME>|${IMAGE_NAME}|g" memberships-deployment.yaml

kubectl apply -f ../datastore
kubectl apply -f .

echo "Describing the configurations"
kubectl describe deploy memberships
