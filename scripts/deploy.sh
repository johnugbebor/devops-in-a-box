#!/bin/bash

set -e

ENV=$1
REGION=$2

if [[ -z "$ENV" || -z "$REGION" ]]; then
  echo "Usage: ./scripts/deploy.sh <env> <region>"
  exit 1
fi

if [ "$ENV" = "production" ]; then
  CLUSTER_NAME="devops-eks-demo-prod"
else
  CLUSTER_NAME="devops-eks-demo-$ENV"
fi

echo "Updating kubeconfig for $ENV in $REGION..."
aws eks update-kubeconfig --name "$CLUSTER_NAME" --region "$REGION"

echo "Deploying app to $ENV in $REGION..."
kubectl apply -f k8s/namespace.yaml
kubectl apply -f k8s/configmap.yaml || true
kubectl apply -f k8s/app-deployment.yaml
kubectl apply -f k8s/service.yaml

echo "Installing Helm and Monitoring Stack..."
curl -s https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts || echo "Repo already exists"
helm repo update
helm upgrade --install prometheus prometheus-community/kube-prometheus-stack -n monitoring --create-namespace

echo "Deployment complete for $ENV in $REGION"
