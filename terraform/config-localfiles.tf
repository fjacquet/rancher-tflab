### The Ansible inventory file
# Save kubeconfig file for interacting with the RKE cluster on your local machine
resource "local_file" "kube_config_server_yaml" {
  filename = format("%s/%s", path.root, "kube_config_server.yaml")
  content  = rke_cluster.rancher_cluster.kube_config_yaml
}

resource "local_file" "kube_config_workload_yaml" {
  filename = format("%s/%s", path.root, "kube_config_workload.yaml")
  content  = rancher2_cluster.workload.kube_config
}
resource "local_file" "rke-config" {
  content = templatefile("cloud-common/files/cluster.template",
    {
      k8s-id  = azurerm_linux_virtual_machine.k8s.*.name,
      k8s-ip  = azurerm_linux_virtual_machine.k8s.*.private_ip_address,
      k8s-pip = azurerm_linux_virtual_machine.k8s.*.public_ip_address
    }
  )
  filename = "cluster.yml"
}
