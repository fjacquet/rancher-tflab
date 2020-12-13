
# Provision RKE cluster on provided infrastructure
resource "rke_cluster" "rancher_cluster" {
  depends_on   = [local_file.rke-config, local_file.ssh_private_key_pem]
  cluster_yaml = file("cluster.yml")

  upgrade_strategy {
    drain                  = true
    max_unavailable_worker = "20%"
  }
}
