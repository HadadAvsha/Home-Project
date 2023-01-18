provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}


resource "helm_release" "argocd" {
  name       = "argo-cd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  namespace  = "default"
  version    = "5.13.8"
  cleanup_on_fail = true
  
  values = [
    file("${path.module}/argo-cd-values.yaml")
  ]

  provisioner "local-exec" {
    command = "bash ~/my_scripts/argo-repo_main-app.sh"
  }
}