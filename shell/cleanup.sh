terraform -chdir=terraform destroy -auto-approve -parallelism=50
ansible-playbook playbooks/clean-files.yml
