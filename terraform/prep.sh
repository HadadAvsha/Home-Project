#!/bin/bash

terraform output controlplane_ip_address | tr -d '",[]' | grep "\S" | cut -c 3-  > ../ansible/masters_ips.txt
terraform output kube-node_ip_address | tr -d '",[]' | grep "\S" | cut -c 3- > ../ansible/workers_ips.txt
echo "[all]" > ../ansible/hosts
cat ../ansible/masters_ips.txt ../ansible/workers_ips.txt >> ../ansible/hosts
echo -e "\n[masters]" >> ../ansible/hosts
cat ../ansible/masters_ips.txt >> ../ansible/hosts
echo -e "\n[workers]" >> ../ansible/hosts
cat ../ansible/workers_ips.txt >> ../ansible/hosts
rm ../ansible/masters_ips.txt ../ansible/workers_ips.txt 