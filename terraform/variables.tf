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
  default = "Standard_D4s_v3"

}

variable "rancher-size" {
  default = "Standard_D2s_v3"
}

variable "longhorn-size" {
  default = "Standard_D2s_v3"
}

variable "data-size" {
  default = "128"
}

variable "vm-user" {
  default = "ubuntu"
}

variable "vm-pass" {
  default = "Demo1234!"
}

variable "count-rancher" {
  default = "3"
}

variable "count-longhorn" {
  default = "2"
}

variable "count-worker" {
  default = "2"
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