
locals {
  mgr_roles    = ["controlplane", "etcd", "worker"]
  worker_roles = ["worker"]
}

# Provision RKE cluster on provided infrastructure
resource "rke_cluster" "rancher_cluster" {

  depends_on            = [azurerm_linux_virtual_machine.k8s]
  kubernetes_version    = var.rke_kubernetes_version
  ignore_docker_version = true
  cluster_name          = "rancher-cluster"
  ssh_agent_auth        = false
  ssh_key_path          = local_file.ssh_private_key_pem.filename

  dynamic "nodes" {
    for_each = azurerm_linux_virtual_machine.k8s
    content {
      address          = nodes.value.public_ip_address
      internal_address = nodes.value.private_ip_address
      user             = var.vm-user
      role             = ["controlplane", "etcd", "worker"]
      ssh_key_path     = local_file.ssh_private_key_pem.filename
    }
  }


  upgrade_strategy {
    drain                  = true
    max_unavailable_worker = "20%"
  }
}
