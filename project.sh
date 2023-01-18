#!/bin/bash
pushd ~/Desktop/Home-Project/terraform
terraform apply -auto-approve
cd ../ansible
bash run.sh

