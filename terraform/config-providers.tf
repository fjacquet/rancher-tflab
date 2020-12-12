# Configure the Azure Provider
provider "azurerm" {
  # whilst the `version` attribute is optional, we recommend pinning to a given version of the Provider
  features {}
  environment     = "public"
  subscription_id = "fcb2e9e2-5c8b-405d-91d4-e780b50549ed"
  tenant_id       = "6adf23d8-eabe-44c8-b68a-0b8fb7aacef9"

}
# Local provider
provider "local" {
}

# RKE provider
provider "rke" {
}

# Kubernetes provider
provider "k8s" {
  host = rke_cluster.rancher_cluster.api_server_url

  client_certificate     = rke_cluster.rancher_cluster.client_cert
  client_key             = rke_cluster.rancher_cluster.client_key
  cluster_ca_certificate = rke_cluster.rancher_cluster.ca_crt

  load_config_file = false
}

# Helm provider
provider "helm" {
  kubernetes {
    host = rke_cluster.rancher_cluster.api_server_url

    client_certificate     = rke_cluster.rancher_cluster.client_cert
    client_key             = rke_cluster.rancher_cluster.client_key
    cluster_ca_certificate = rke_cluster.rancher_cluster.ca_crt

    load_config_file = false
  }
}

# Rancher2 bootstrapping provider
provider "rancher2" {
  alias = "bootstrap"

  api_url  = "https://${var.rancher_server_dns}"
  insecure = true
  # ca_certs  = data.kubernetes_secret.rancher_cert.data["ca.crt"]
  bootstrap = true
}

# Rancher2 administration provider
provider "rancher2" {
  alias = "admin"

  api_url  = "https://${var.rancher_server_dns}"
  insecure = true
  # ca_certs  = data.kubernetes_secret.rancher_cert.data["ca.crt"]
  token_key = rancher2_bootstrap.admin.token
}
