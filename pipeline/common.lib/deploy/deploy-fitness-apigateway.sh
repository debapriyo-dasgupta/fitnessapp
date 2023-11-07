#!/bin/bash

echo "Configurations will be applied in the below namespace-----"
kubectl config view --minify | grep namespace:

# Deploy the environment specific configurations
cd applications/apigateway/manifests/

kubectl apply -f .
kubectl apply -f ../virtualservices/

echo "Describing the configurations"
kubectl describe deploy api-gateway
