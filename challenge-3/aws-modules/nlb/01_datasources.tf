data "aws_instances" "asg_instances" {
  filter {
    name   = "tag:Name"
    values = [var.asg_name]
  }
}

data "aws_security_groups" "this" {
  filter {
    name   = "group-name"
    values = ["default"]
  }
}