### The Ansible inventory file
# Save kubeconfig file for interacting with the RKE cluster on your local machine
resource "local_file" "kube_config_server_yaml" {
  filename = format("%s/%s", path.root, "kube_config_server.yaml")
  content  = rke_cluster.rancher_cluster.kube_config_yaml
}

resource "local_file" "kube_config_workload_yaml" {
  filename = format("%s/%s", path.root, "kube_config_workload.yaml")
  content  = rancher2_cluster.quickstart_workload.kube_config
}
resource "local_file" "rke-config" {
  content = templatefile("cloud-common/files/cluster.template",
    {
      rancher-id   = azurerm_linux_virtual_machine.rancher.*.name,
      rancher-ip   = azurerm_linux_virtual_machine.rancher.*.private_ip_address,
      rancher-pip  = azurerm_linux_virtual_machine.rancher.*.public_ip_address,
      longhorn-id  = azurerm_linux_virtual_machine.longhorn.*.name,
      longhorn-ip  = azurerm_linux_virtual_machine.longhorn.*.private_ip_address,
      longhorn-pip = azurerm_linux_virtual_machine.longhorn.*.public_ip_address,
      worker-id    = azurerm_linux_virtual_machine.worker.*.name,
      worker-ip    = azurerm_linux_virtual_machine.worker.*.private_ip_address,
      worker-pip   = azurerm_linux_virtual_machine.worker.*.public_ip_address
    }
  )
  filename = "manual-cluster.yml"
}
