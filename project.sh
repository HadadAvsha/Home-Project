#!/bin/bash
pushd ~/Desktop/Home-Project/terraform
terraform apply -auto-approve
cd ../ansible
bash run.sh
sleep 120
helm install argo-cd -f ../terraform/argo-cd-values.yaml argo/argo-cd --version 5.8.3
sleep 60
bash ~/my_scripts/argo-repo_main-app.sh