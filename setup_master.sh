#!/bin/bash

# Ask for the remote host IP
read -p "Enter remote host IP: " remote_host_ip

# Edit the kubeconfig to access the master node
kubectl config set-cluster k3s-default \
  --server=https://$remote_host_ip:6443 \
  --insecure-skip-tls-verify=true
kubectl config set-context k3s-default \
  --cluster=k3s-default
kubectl config use-context k3s-default
