#!/bin/bash

# Install arkade on local host
curl -SLsf https://dl.get-arkade.dev | sudo sh

# Ask for the remote host IP and add it to /etc/hosts
read -p "Enter remote host IP: " remote_host_ip
read -p "Enter a name for the remote host: " remote_host_name
read -p "Enter the user for the remote host: " remote_user
echo "$remote_host_ip $remote_host_name" | sudo tee -a /etc/hosts

# Create a ssh key and copy it to remote host
ssh_key_file=arkade_key
ssh-keygen -t rsa -b 2048 -f ~/.ssh/$ssh_key_file
ssh-copy-id -i ~/.ssh/$ssh_key_file.pub $remote_user@$remote_host_name

# Install necessary tools on remote host using arkade
arkade get helm kubectl k3sup

k3sup install --ip $remote_host_ip --user $remote_user \
  --ssh-key ~/.ssh/$ssh_key_file \
  --context $(kubectl config current-context) \
  --cluster

# Verify that installations were successful
if [ $? -eq 0 ]; then
  echo "Installations were successful."
else
  echo "Installation failed. Please check logs for more information."
fi
