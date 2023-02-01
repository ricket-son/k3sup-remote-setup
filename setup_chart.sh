#!/bin/bash

# Define the name for the release
release_name="prometheus-stack"

# Define the port to expose
port=3000

## Define the adminPassword
password=Passwort

# Check if the chart is already installed
if helm ls | grep $release_name &> /dev/null; then
  echo "Updating chart $release_name"
  helm upgrade $release_name prometheus-community/kube-prometheus-stack \
    --set grafana.service.type=LoadBalancer \
    --set grafana.service.port=$port \
    --set grafana.adminPassword=$password
else
  echo "Installing chart $release_name"
  helm install $release_name prometheus-community/kube-prometheus-stack \
    --set grafana.service.type=LoadBalancer \
    --set grafana.service.port=$port \
    --set grafana.adminPassword=$password
fi

# Check the status of the release
echo "Checking status of release $release_name"
helm status $release_name
