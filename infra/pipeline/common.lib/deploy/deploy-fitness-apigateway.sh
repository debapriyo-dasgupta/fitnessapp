#!/bin/bash
# Load the utility functions
. infra/pipeline/common.lib/utils/get-version.sh

echo "Configurations will be applied in the below namespace-----"
kubectl config view --minify | grep namespace:

# Deploy the environment specific configurations
cd applications/apigateway/manifests/

read VERSION IMAGE_NAME < <(get-version "../version.txt")
echo "IMAGE DETAILS - $IMAGE_NAME:$VERSION"

# Deploy the target manifests to create the runtimes/pods
sed -i "s/<TAG>/${VERSION}/g" apigateway.yaml
sed -i "s|<IMAGE_NAME>|${IMAGE_NAME}|g" apigateway.yaml

kubectl apply -f .

echo "Describing the configurations"
kubectl describe deploy api-gateway
