output "vpn_ip" {
  value = aws_instance.vpn.*.public_ip
}
output "master" {
  value = { name = aws_instance.master.*.tags.Name,
            ip = aws_instance.master.*.private_ip }
}
output "worker" {
  value = { name = aws_instance.worker.*.tags.Name,
            ip = aws_instance.worker.*.private_ip }
}