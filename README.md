# Rancher lab using terraform and ansilbe

Sample terraform and ansible code to generate some rancher cluster in azure

### Deploy

To begin with this environment, perform the following steps:

1. Clone or download this repository to a local folder
1. Use az -login
1. Run setupAll.sh

When provisioning has finished, terraform will output the URL to connect to the Rancher server.
Two sets of Kubernetes configurations will also be generated:
- `kube_config_server.yaml` contains credentials to access the RKE cluster supporting the Rancher server
- `kube_config_workload.yaml` contains credentials to access the provisioned workload cluster

For more details on each cloud provider, refer to the documentation in their respective folders.

### Remove

When you're finished exploring the Rancher server, use terraform to tear down all resources.

**NOTE: Any resources not provisioned by the script are not guaranteed to be destroyed when tearing down the script.**
Make sure you tear down any resources you provisioned manually before running the destroy command.

Run `terraform destroy -auto-approve` to remove all resources without prompting for confirmation.