resource "local_file" "ansible_inventory" {
  content = templatefile("templates/inventory.tmpl", {
    master   = data.terraform_remote_state.environment.outputs.master
    worker   = data.terraform_remote_state.environment.outputs.worker
  })
  filename = "../../ansible/kubespray/inventory/mycluster/inventory.ini"

   provisioner "local-exec" {command = "sleep 10 && ansible-playbook -i ../../ansible/kubespray/inventory/mycluster/inventory.ini -v --become --become-user=root ../../ansible/kubespray/cluster.yml"}
 }