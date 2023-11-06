#!/bin/bash
# Load the utility functions
. pipeline/common.lib/utils/get-version.sh

kubectl config set-context --current --namespace=$2

echo "Configurations will be applied in the below namespace-----"
kubectl config view --minify | grep namespace:

# Deploy the environment specific configurations
cd applications/terracotta-bigmemory/env-manifests/$1
kubectl apply -f .

read VERSION IMAGE_NAME < <(get-version "../../version.txt")
echo "IMAGE DETAILS - $IMAGE_NAME:$VERSION"

# Deploy the target manifests to create the runtimes/pods
cd ../../manifests
sed -i "s/<TAG>/${VERSION}/g" tsa-statefulsets.yaml
sed -i "s|<IMAGE_NAME>|${IMAGE_NAME}|g" tsa-statefulsets.yaml
# Deploy the target manifests to create the runtimes/pods
kubectl apply -f .

echo "Describing the configurations"
kubectl describe sts terracotta-bigmemory

# TSA BM should be up
echo "Waiting for TSA BM to be up and running"
kubectl wait --for=condition=ready --timeout=300s pod -l app=terracotta
