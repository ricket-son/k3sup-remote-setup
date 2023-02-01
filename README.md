
# using k3sup to setup remote environments



## Requirements

### remote machine
- install curl
- setup ssh
- setup ssh-config: PermitRootLogin

### local machine
- arkade on host-machine
- sudo user

1. creating a key-pair
1.1 creating a ssh key

		ssh-keygen 

	1.2 copying ssh key to remote machine

		ssh-copy-id -i {file} {remote-host}

2. setting up the machine
	2.1 installing k3sup
	
		arkade get k3sup
		
	2.2 installing helm

		arkade install helm		

	2.3 installing kubectl

		arkade get kubectl
		
3. configure the master with k3sup

		k3sup install --ip $remote_host_ip --user $remote_user \
			--ssh-key ~/.ssh/$ssh_key_file \
			--context $(kubectl config current-context) \
			--cluster

4. configure the kubeconfig

		export KUBECONFIG=kubeconfig

5. creating helm charts

		helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
		helm install my-kube-prometheus-stack prometheus-community/kube-prometheus-stack --version 44.3.0


	Script to prepare the chart
		
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


		
