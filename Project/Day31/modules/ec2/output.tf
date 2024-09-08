output "pub_sg_id" {
  value = aws_security_group.pub_sg.id
}
output "Public_ip_ec2" {
    value = aws_instance.my-ec2.public_ip
}