# add kubernetes dashboard
resource "null_resource" "setup_kubernetes_dashboard" {
  depends_on = ["module.eks"]

  triggers = {
    kubernetes_dashboard_manifest = "${sha1(file("kubernetes-manifests/kubernetes-dashboard.yaml"))}"
    kubernetes_dashboard_rbac_manifest = "${sha1(file("kubernetes-manifests/kubernetes-dashboard-rbac.yaml"))}"
  }

  provisioner "local-exec" {
    working_dir = "${path.module}"

    command = <<EOS
kubectl apply -f kubernetes-manifests/kubernetes-dashboard-rbac.yaml --kubeconfig .kube_config.yaml
kubectl apply -f kubernetes-manifests/kubernetes-dashboard.yaml --kubeconfig .kube_config.yaml
EOS
  }
}
