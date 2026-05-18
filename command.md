# run audit of section 2 
ansible-playbook -i intialize-environment/ansible/inventory.ini \
  sections/2.Installation_and_Planning/site.yml -e audit_type=automated
