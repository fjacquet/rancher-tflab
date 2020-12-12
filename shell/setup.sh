set -x
echo "Sign in needed."


# cd terraform
# Create infra
terraform -chdir=terraform apply -auto-approve -refresh=true -parallelism=50
#
# prepare id
ansible-playbook playbooks/create-links.yml

# add ssh key
ssh-add terraform/id_rsa
# Configure VMs
ansible-playbook --private-key=id_rsa -i myazure_rm.yml playbooks/prepare-rancher.yml
# Build cluster
rke up --config terraform/cluster.yml
# Get helm setup
# helm repo add rancher-stable      	https://releases.rancher.com/server-charts/stable
helm repo add rancher-latest https://releases.rancher.com/server-charts/latest
helm repo add jetstack https://charts.jetstack.io
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo add elastic https://helm.elastic.co
helm repo add bitnami https://charts.bitnami.com/bitnami
# Update your local Helm chart repository cache
helm repo update
chmod 400 kube_config_cluster.yml
export KUBECONFIG=kube_config_cluster.yml

# Install the CustomResourceDefinition resources separately
kubectl apply --validate=false -f https://github.com/jetstack/cert-manager/releases/download/v1.0.4/cert-manager.crds.yaml
# Create the namespace for cert-manager
kubectl create namespace cert-manager
kubectl create namespace cattle-system
kubectl create namespace elastic-system
# Install the cert-manager Helm chart
helm install cert-manager jetstack/cert-manager --namespace cert-manager --version v1.0.4
# Install the rancher  Helm chart
helm install rancher rancher-latest/rancher --namespace cattle-system --set hostname=rancher.ljf.home
# Install elastic operator
kubectl apply -f https://download.elastic.co/downloads/eck/1.3.1/all-in-one.yaml