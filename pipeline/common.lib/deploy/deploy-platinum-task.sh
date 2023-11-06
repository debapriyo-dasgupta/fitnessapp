#!/bin/bash
# Load the utility functions
. pipeline/common.lib/utils/get-version.sh
kubectl config set-context --current --namespace=$2

echo "Configurations will be applied in the below namespace-----"
kubectl config view --minify | grep namespace:

# Deploy the environment specific configurations
cd applications/platinum-msr/env-manifests/$1
kubectl apply -f .

read VERSION IMAGE_NAME < <(get-version "../../version.txt")
echo "IMAGE DETAILS - $IMAGE_NAME:$VERSION"

# Deploy the target manifests to create the runtimes/pods
cd ../../manifests
sed -i "s/<TAG>/${VERSION}/g" platinum-sts.yaml
sed -i "s|<IMAGE_NAME>|${IMAGE_NAME}|g" platinum-sts.yaml

kubectl apply -f .

#kubectl apply -f ../demo-multi-versions/

echo "Describing the configurations"
kubectl describe cm platinum-msr-appprop-cm webmethodslicensekeys
kubectl describe sts platinum-msr
