#!/bin/bash

echo "Configurations will be applied in the below namespace-----"
kubectl config view --minify | grep namespace:

echo "Install the Observability - Components"
kubectl apply -k k8s-env-manifests/overlays/olly/

