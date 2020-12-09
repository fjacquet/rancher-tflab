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
  default = "Standard_B1s"
}

variable "rancher-size" {
  default = "Standard_B1s"
}

variable "longhorn-size" {
  default = "Standard_B1s"
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
  default = "2"
}

variable "count-longhorn" {
  default = "1"
}

variable "count-worker" {
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
