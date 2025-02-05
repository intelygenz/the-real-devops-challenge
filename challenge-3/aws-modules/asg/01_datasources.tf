data "aws_security_groups" "this" {
  filter {
    name   = "group-name"
    values = ["default"]
  }
  filter {
    name   = "vpc-id"
    values = [var.vpc_id]
  }
}


data "aws_instances" "asg_instances" {
  filter {
    name   = "tag:Name"
    values = [var.asg_name]
  }
}


