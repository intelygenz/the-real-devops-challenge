data "aws_subnets" "nlb_subnets" {
  filter {
    name   = "tag:Name"
    values = ["public-subnet-a", "private-subnet-b", "private-subnet-c"] 
  }
}

data "aws_security_groups" "nlb-sg-ids" {
  filter {
    name   = "group-name"
    values = ["nlb-sg"]
  }
}