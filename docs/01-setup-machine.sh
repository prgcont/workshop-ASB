#!/bin/bash 

# Adjust the version to your liking. Follow installation docs
# at https://github.com/kubernetes/minikube.
minikube start --bootstrapper kubeadm --kubernetes-version v1.9.4

# Install helm and tiller. See documentation for obtaining the helm
# binary. https://docs.helm.sh/using_helm/#install-helm
helm init

# Wait until tiller is ready before moving on
until kubectl get pods -n kube-system -l name=tiller | grep 1/1; do sleep 1; done

kubectl create clusterrolebinding tiller-cluster-admin --clusterrole=cluster-admin --serviceaccount=kube-system:default

# Adds the chart repository for the service catalog
helm repo add svc-cat https://svc-catalog-charts.storage.googleapis.com

# Installs the service catalog helm install svc-cat/catalog --name catalog --namespace catalog
helm install svc-cat/catalog --name catalog --namespace catalog

# Wait until the catalog is ready before moving on
until kubectl get pods -n catalog -l app=catalog-catalog-apiserver | grep 2/2; do sleep 1; done
until kubectl get pods -n catalog -l app=catalog-catalog-controller-manager | grep 1/1; do sleep 1; done

./scripts/run_latest_k8s_build.sh
