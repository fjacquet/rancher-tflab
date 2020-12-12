output "rancher_url" {
  value = "https://${var.rancher_server_dns}"
}

output "custom_cluster_command" {
  value       = rancher2_cluster.quickstart_workload.cluster_registration_token.0.node_command
  description = "Docker command used to add a node to the quickstart cluster"
}

output "custom_cluster_windows_command" {
  value       = rancher2_cluster.quickstart_workload.cluster_registration_token.0.windows_node_command
  description = "Docker command used to add a windows node to the quickstart cluster"
}


// output "client_certificate" {
//   value = azurerm_kubernetes_cluster.aks-worker.kube_config.0.client_certificate
// }

// output "kube_config" {
//   value = azurerm_kubernetes_cluster.aks-worker.kube_config_raw
// }