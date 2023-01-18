#!/bin/bash
echo "CDing to terraform directory"
pushd ../terraform && bash prep.sh
echo "Getting the IP of the VMs"
popd
echo "Copy necessary files to /tmp"
cp metrics-server.yaml /tmp/
echo "Running Prerequisites installations on all VMs"
ansible-playbook -i hosts all_pre.yml
#ansible-playbook -i hosts all_install-k8s.yml
echo "Setting up the controlplane"
ansible-playbook -i hosts masters_playbook.yml
echo "Setting up the worker nodes"
ansible-playbook -i hosts workers_playbook.yml
echo "Setting up kube/config"
mv fetched/admin.conf ~/.kube/config
echo "chmoding .kube/config to only readable by me"
chmod 600 ~/.kube/config
kubectl get nodes
