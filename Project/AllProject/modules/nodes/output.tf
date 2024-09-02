output "master_node_ip"  {
    value = aws_instance.master.public_ip
}
output "worker_node1_ip" {
    value = aws_instance.worker[0].public_ip
}
output "worker_node2_ip" {
    value = aws_instance.worker[1].public_ip
}