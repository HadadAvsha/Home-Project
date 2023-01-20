provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}


resource "helm_release" "argocd" {
  depends_on = [null_resource.ModifyApplyAnsiblePlayBook]

    # provisioner "local-exec" {
    #     interpreter = ["/bin/bash", "-c"]
    #     command = <<-EOT
    #         bash ~/my_scripts/argo-repo_main-app.sh
    #     EOT
    # }

  name       = "argo-cd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  namespace  = "default"
  version    = "5.13.8"
  cleanup_on_fail = true
  
  values = [
    file("argo-cd-values.yaml")
  ]

  provisioner "local-exec" {

    interpreter = ["/bin/bash", "-c"]
    command = <<-EOT
        bash ~/my_scripts/argo-repo_main-app.sh
    EOT
  }
}