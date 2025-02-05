resource "aws_lb" "this" {
  name               = "nlb"
  internal           = var.internal
  load_balancer_type = "network"
  subnets            = var.subnet_ids
  security_groups    = [aws_security_group.nlb-sg.id]

  enable_deletion_protection = false # TESTING PURPOSE

  tags = {
    Environment = "dev"
  }
}


resource "aws_lb_listener" "this" {
  for_each = var.target_groups
  load_balancer_arn = aws_lb.this.arn
  port              = "80"
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this[each.key].arn
  }
}


resource "aws_lb_target_group" "this" {
  for_each      = var.target_groups
  name          = lookup(each.value, "name", null)
  port          = lookup(each.value, "port", null)
  target_type   = lookup(each.value, "target_type", null)
  protocol      = lookup(each.value, "protocol", null)
  vpc_id        = var.vpc_id

  target_health_state {
    enable_unhealthy_connection_termination = false
  }


  health_check {
    enabled     = true
    interval    = 9
    port        = "traffic-port"
    path        = "/"
    protocol    = lookup(each.value, "health_check_protocol", null)
  }
}


resource "aws_lb_target_group_attachment" "example" {
  for_each = { for v in local.tg_attachments : v.key => v }

  target_group_arn = each.value.target_group_arn
  target_id        = each.value.instance_id
  port             = each.value.port
}


# Security group for the Network Load Balancer
resource "aws_security_group" "nlb-sg" {
  name = "nlb-sg"
  description = "NLB security group"
  vpc_id      = var.vpc_id
    // inbound vpc access
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.cidrs.primary, var.cidrs.secondary[0]]
  }
   // internet http access 
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  // internet https access 
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
    // http egress outside
  egress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "nlb-sg"
  }
}


# added nlb ingress to vpc default sg
resource "aws_vpc_security_group_ingress_rule" "asg-nlb-ingress" {
  security_group_id = var.default_sg
  referenced_security_group_id =  aws_security_group.nlb-sg.id #passar sg do nlb
  from_port   = 80
  ip_protocol = "tcp"
  to_port     = 80
}

#added  vpc sg to nlb egress of the nlb sg

resource "aws_vpc_security_group_egress_rule" "asg-nlb-egress" {
  security_group_id = aws_security_group.nlb-sg.id # nlb sg
  referenced_security_group_id = var.default_sg 
  from_port   = 80
  ip_protocol = "tcp"
  to_port     = 80
}