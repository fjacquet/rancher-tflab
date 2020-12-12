variable "prefix" {
  default = "tf-rancher"
}

variable "location" {
  default = "West Europe"
}

variable "enable_accelerated_networking" {
  default = "false"
}
# Standard_E4as_v4

variable "worker-size" {
  default = "Standard_D4s_v4"
}

variable "mgmt-size" {
  default = "Standard_D2s_v4"
}
variable "rancher-size" {
  default = "Standard_D2s_v4"
}

variable "longhorn-size" {
  default = "Standard_D2s_v4"
}

variable "data-size" {
  default = "128"
}

variable "vm-user" {
  default = "ubuntu"
}

variable "vm-passwd" {
  default = "Azure4Passw0rd!"
}

variable "count-rancher" {
  default = "0"
}

variable "count-longhorn" {
  default = "3"
}

variable "count-worker" {
  default = "0"
}
variable "count-mgmt" {
  default = "1"
}
variable "environment" {
  default = "demo"
}

variable "vnet-main" {
  default = "10.0.0.0/16"
}

variable "subnet-main" {
  default = "10.0.2.0/24"
}

variable "sku" {
  default = "18.04-LTS"
}



# Required
variable "node_public_ip" {
  type        = string
  description = "Public IP of compute node for Rancher cluster"
}

variable "node_internal_ip" {
  type        = string
  description = "Internal IP of compute node for Rancher cluster"
  default     = ""
}

# Required
variable "node_username" {
  type        = string
  description = "Username used for SSH access to the Rancher server cluster node"
}

# Required
variable "ssh_private_key_pem" {
  type        = string
  description = "Private key used for SSH access to the Rancher server cluster node"
}

variable "rke_kubernetes_version" {
  type        = string
  description = "Kubernetes version to use for Rancher server RKE cluster"
  default     = "v1.19.3-rancher1-2"
}

variable "cert_manager_version" {
  type        = string
  description = "Version of cert-manager to install alongside Rancher (format: 0.0.0)"
  default     = "1.0.4"
}

variable "rancher_version" {
  type        = string
  description = "Rancher server version (format v0.0.0)"
  default     = "v2.5.2"
}

# Required
variable "rancher_server_dns" {
  type        = string
  description = "DNS host name of the Rancher server"
  default     = "rancher.ljf.home"
}

# # Required
variable "admin_password" {
  type        = string
  description = "Admin password to use for Rancher server bootstrap"
  default     = "Azure4Passw0rd!"
}

variable "workload_kubernetes_version" {
  type        = string
  description = "Kubernetes version to use for managed workload cluster"
  default     = "v1.18.10-rancher1-2"
}

# Required
variable "workload_cluster_name" {
  type        = string
  description = "Name for created custom workload cluster"
  default     = "workers"
}

variable "rke_network_plugin" {
  type        = string
  description = "Network plugin used for the custom workload cluster"
  default     = "canal"
}

variable "rke_network_options" {
  description = "Network options used for the custom workload cluster"
  default     = null
}

variable "windows_prefered_cluster" {
  type        = bool
  description = "Activate windows supports for the custom workload cluster"
  default     = false
}
