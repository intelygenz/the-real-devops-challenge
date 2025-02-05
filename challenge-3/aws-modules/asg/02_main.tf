resource "aws_launch_template" "this" {
  name = "el-launch-template" # TODO variable

  iam_instance_profile {
    arn = "arn:aws:iam::811931148196:instance-profile/SSM" # TODO output needed 
  }


  vpc_security_group_ids  = [var.default_sg]
  # Basic configuration for the launch template
  block_device_mappings {
    device_name = "/dev/xvda"

    ebs {
      volume_size = 8
      volume_type = "gp2"
    }
  }

  # Network configuration for the launch template
  dynamic "network_interfaces" {
    for_each = { for idx, nic in local.network_interfaces : idx => nic }

    content {
      associate_public_ip_address = network_interfaces.value.associate_public_ip_address
      delete_on_termination       = network_interfaces.value.delete_on_termination
      device_index                = network_interfaces.value.device_index
      subnet_id                   = network_interfaces.value.subnet_id
      security_groups             = network_interfaces.value.security_groups
    }
  }

  # Specify the instance type
  instance_type = "t2.micro"

  # Specify the AMI ID
  image_id = "ami-00cf59bc9978eb266"  # Replace with your desired AMI ID

  # Optional key pair for SSH access
  #key_name = "your-key-pair"  # Replace with your key pair name if needed

  # Tags for the launch template
  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "el-instance"
      environmrnt = "Dev"
    }
  }

  user_data = filebase64("${path.module}/user_data.sh")
}


resource "aws_autoscaling_group" "this" {
  name                      = var.asg_name
  launch_template {
    id      = aws_launch_template.this.id
    version = aws_launch_template.this.latest_version
  }
  #placement_group           = aws_placement_group.this.id
  vpc_zone_identifier       = var.subnet_ids 
  min_size                  = 0
  max_size                  = 2
  desired_capacity          = 2
  health_check_type         = "EC2"
  health_check_grace_period = 300

  tag {
      key                 = "Name"
      value               = var.asg_name
      propagate_at_launch = true
    }
  
}



# Elastic IP for NAT Gateway
resource "aws_eip" "nat" {
  domain = "vpc"
}

resource "aws_nat_gateway" "this" {
  allocation_id = aws_eip.nat.id
  subnet_id     = var.nat_subnet_id[0] 

  tags = {
    Name = "Public Nat GW"
  }
  depends_on = [aws_eip.nat]
}


# Create a route to the NAT Gateway in the private route table if is already created in console(to avoid cost)

resource "aws_route" "private" {
  route_table_id         = var.private_routable_id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.this.id
}