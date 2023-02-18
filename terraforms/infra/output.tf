output "vpn_ip" {
  value = aws_instance.vpn.*.public_ip
}
output "master_ip" {
  value = aws_instance.master.*.private_ip
}