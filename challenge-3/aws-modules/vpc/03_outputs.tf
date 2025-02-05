output "public_subnet_ids" {
  value = [for subnet in aws_subnet.public_subnets : subnet.id]
}

output "private_subnet_ids" {
  value = [for subnet in aws_subnet.private_subnets : subnet.id]
}
output "nlb_subnets_ids" {
  value = data.aws_subnets.nlb_subnets.ids
}

output "vpc_id" {
  value = aws_vpc.this.id  
}
output default_sg_id {
  value       = aws_default_security_group.default.id
  description = "default sg"
}

output private_routable_id {
  value       = aws_route_table.private.id
  description = "The private route table id"
}

output "public_subnet_a_id" {
  value = [
    for subnet in aws_subnet.public_subnets :
    subnet.id
    if subnet.tags["Name"] == "public-subnet-a"
  ]
  description = "the public-subnet-a iD"
}
