### The Ansible inventory file
resource "local_file" "rke-config" {
  content = templatefile("cluster.tmpl",
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
  filename = "rke-cluster.yml"
}