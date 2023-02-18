resource "local_file" "ansible_inventory" {
filename = "../../ansible/wireguard/inventory"
content = <<EOF
[vpn]
hostname=wireguard ansible_ssh_host="${data.terraform_remote_state.environment.outputs.vpn_ip[0]}" ansible_user=ubuntu ansible_ssh_common_args='-o StrictHostKeyChecking=no'
ansible_python_interpreter = /usr/bin/python3
ssh_args = -o StrictHostKeyChecking=no -oCompression=yes
inventory = ./inventory
EOF
provisioner "local-exec" {command = "sleep 10 && ansible-playbook -i ../../ansible/wireguard/inventory -v ../../ansible/wireguard/run.yaml"}
}