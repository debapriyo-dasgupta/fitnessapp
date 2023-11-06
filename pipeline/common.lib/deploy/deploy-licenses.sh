#!/bin/bash
echo "Configurations will be applied in the below namespace-----"
kubectl config view --minify | grep namespace:

# Deploy the environment specific configurations
cd licenses

kubectl apply -f .

echo "Describing the configurations"
kubectl describe cm webmethodslicensekeys
