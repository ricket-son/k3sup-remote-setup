#!/bin/bash

# Define the IP address of the new worker node
read -p "Enter the remote IP of the master you want to add workers to: " server_ip
read -p "Enter the remote IP of the worker you want to add: " worker_node_ip
read -p "Enter the user you want to use on the remote machine: " user
read -p "Enter the path of the key: " ssh_key

# Join the machine to the server with k3s
k3sup join --ip $worker_node_ip --server-ip $server_ip --user $user --ssh-key $ssh_key 

# Verify that the worker node has joined the cluster
kubectl get nodes -o wide
