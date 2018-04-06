#!/bin/bash

# Adjust the version to your liking. Follow installation docs
# at https://github.com/kubernetes/minikube.
minikube start --bootstrapper kubeadm --kubernetes-version v1.9.4

# Install helm and tiller. See documentation for obtaining the helm
# binary. https://docs.helm.sh/using_helm/#install-helm
helm init --wait

kubectl create clusterrolebinding tiller-cluster-admin --clusterrole=cluster-admin --serviceaccount=kube-system:default

# Adds the chart repository for the service catalog
helm repo add svc-cat https://svc-catalog-charts.storage.googleapis.com

# Installs the service catalog helm install svc-cat/catalog --name catalog --namespace catalog
helm install --wait svc-cat/catalog --name catalog --namespace catalog

./scripts/run_latest_k8s_build.sh
