#!/bin/bash
#setting up some env

cidr_block=192.168.100.0/24
cidr_base_addr=${cidr_block%???}
ingress_first_addr=192.168.100.70
ingress_last_addr=192.168.100.80
ingress_range=$ingress_first_addr-$ingress_last_addr

#deploying MetalLB
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.10.2/manifests/namespace.yaml
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.10.2/manifests/metallb.yaml

cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: ConfigMap
metadata:
  namespace: metallb-system
  name: config
data:
  config: |
    address-pools:
    - name: default
      protocol: layer2
      addresses:
      - $ingress_range
EOF
#validating 
# kubectl create deployment nginx --image=nginx
# kubectl expose deployment nginx --port=80 --type=LoadBalancer
# external_ip=$(kubectl get svc nginx -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
# curl $external_ip
# kubectl delete deployments.apps nginx
# kubectl delete service nginx
