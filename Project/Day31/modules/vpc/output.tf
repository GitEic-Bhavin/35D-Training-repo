output "vpc_id" {
  value = aws_vpc.newvpc.id
}
output "igw-name" {
  value = aws_internet_gateway.igw_bhavin.id

}
output "pub_sub_id" {
  value = aws_subnet.pub-sub.id

}
output "pvt_sub_id" {
  value = aws_subnet.pvt-sub.id

}
output "pvt_sub2_id" {
  value = aws_subnet.pvt-sub2.id
  
}