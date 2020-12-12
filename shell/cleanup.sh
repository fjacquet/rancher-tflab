terraform -chdir=terraform destroy -auto-approve
ansible-playbook playbooks/clean-files.yml
