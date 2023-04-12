# Home-Project<br/>
## CI location: [Gitlab](https://gitlab.com/hadadavsha/grade-app)<br/>
![image](https://user-images.githubusercontent.com/106066816/213912671-3bfb2d6e-d769-4c42-aef6-cfa90537d8d9.png)<br/>

using proxmox, terraform, ansible, kubernetes, helm, argo-cd, hashicoprt vault and more


if youre running on < 3th gen intel CPU take into considiration that 


On my way to complete the CKA certificate i wanted to expiriment on a full k8s cluster(not kind, k3s or any variation), instead of paying for managed service or VMs in a cloud provider i decided to use some hardware i have laying around and setup my own cluster.
This project got very interesting and i wanted to do more then just setup a cluster, so i used some of the tools i gainned during my devops bootcamp (and a bit more..).
With automation and IaC in mind i decided on using Proxmox as my hypervisor of choice since it is open source and have an API to communicate with terraform.#(how to link)
The next step is to create a image template for the VMs(#link to usefull guide), i decided to use ubuntu 20.04 as base image, you can use Roi`s guide on creating cloud-init template.
Provisioning Vms in Terraform (im using 1 master and 2 workers) for k8s, more info in main.tf.
once we have the VMs up and running we need to install some prerequisite for k8s to be fully operational using Ansible.
    - NFS share for backuping up PV
    - 