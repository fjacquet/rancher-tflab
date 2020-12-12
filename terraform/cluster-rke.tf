
# Provision RKE cluster on provided infrastructure
resource "rke_cluster" "rancher_cluster" {
  cluster_name = "rancher"

  nodes {
    address          = var.node_public_ip
    internal_address = var.node_internal_ip
    user             = var.node_username
    role             = ["controlplane", "etcd", "worker"]
    ssh_key          = local_file.ssh_private_key_pem
  }

  kubernetes_version = var.rke_kubernetes_version
}
