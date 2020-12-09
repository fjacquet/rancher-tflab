
echo "You should be logged in Azure already"
# Create infra
terraform apply --auto-approve
# add ssh key
ssh-add id_rsa
# Configure VMs
ansible-playbook --private-key=id_rsa -i myazure_rm.yml ans-docker.yml
# Build cluster
rke up --config cluster.yml
# Get helm setup
# helm repo add rancher-stable      	https://releases.rancher.com/server-charts/stable
helm repo add rancher-latest        https://releases.rancher.com/server-charts/latest
helm repo add jetstack            	https://charts.jetstack.io
helm repo add prometheus-community	https://prometheus-community.github.io/helm-charts
helm repo add elastic             	https://helm.elastic.co
helm repo add bitnami             	https://charts.bitnami.com/bitnami

export KUBECONFIG=./kube_config_cluster.yml

kubectl create namespace cattle-system

helm install rancher rancher-latest/rancher \
  --namespace cattle-system \
  --set hostname=rancher.ljf.home


# helm install rancher rancher-latest/rancher \
#   --namespace cattle-system \
#   --set hostname=rancher.my.org \
#   --set ingress.tls.source=letsEncrypt \
#   --set letsEncrypt.email=me@example.org