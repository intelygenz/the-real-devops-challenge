# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# DEPLOY A SINGLE EC2 INSTANCE
# This template runs a simple "Hello, World" web server on a single EC2 Instance
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# ----------------------------------------------------------------------------------------------------------------------
# REQUIRE A SPECIFIC TERRAFORM VERSION OR HIGHER
# ----------------------------------------------------------------------------------------------------------------------

terraform {
  # This module is now only being tested with Terraform 0.13.x. However, to make upgrading easier, we are setting
  # 0.12.26 as the minimum version, as that version added support for required_providers with source URLs, making it
  # forwards compatible with 0.13.x code.
  required_version = ">= 0.12.26"
}

# ------------------------------------------------------------------------------
# CONFIGURE OUR AWS CONNECTION
# ------------------------------------------------------------------------------

provider "aws" {
  region  = var.region
  profile = var.profile
}

# ---------------------------------------------------------------------------------------------------------------------
# EC2 KEY PAIR
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_key_pair" "ec2_demo_key" {
  key_name   = "aws_ec2_key"
  public_key = file(var.ec2_public_key)
}

# ---------------------------------------------------------------------------------------------------------------------
# DEPLOY EC2 INSTANCES
# ---------------------------------------------------------------------------------------------------------------------
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}


data "template_file" "user_data" {
  template = file("./cloud-init/add-user-jenkins-ssh.yaml")

  vars = {
    worker_public_key   = file(var.ec2_public_key)
    worker_private_key  = file(var.ec2_private_key)
  }
}


resource "aws_instance" "jenkins-slave" {
  count = var.instance_count

  #ami                    = data.aws_ami.ubuntu.id
  ami                    = var.ami
  instance_type          = var.instance_type
  key_name               = aws_key_pair.ec2_demo_key.key_name
  vpc_security_group_ids = [ aws_security_group.ssh.id, 
                             aws_security_group.tls.id,
                             aws_security_group.http.id ]
  user_data              = data.template_file.user_data.rendered

  tags = {
    name = format("jenkins-agent-%d",count.index)
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# CREATE THE SSH SECURITY GROUP THAT'S APPLIED TO THE EC2 INSTANCE
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_security_group" "ssh" {
  name        = "jenkins-agent-ssh"
  description = "Security group for nat instances that allows SSH and VPN traffic from/to internet"
  
  lifecycle {
    create_before_destroy = true
  }
}

# Inbound SSH from anywhere
resource "aws_security_group_rule" "allow-ssh-inbound" {
  description       = "SSH from VPC"
  type              = "ingress"
  security_group_id = aws_security_group.ssh.id

  from_port   = var.ssh_port
  to_port     = var.ssh_port
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}

# Outbound SSH to anywhere
resource "aws_security_group_rule" "allow-ssh-outbound" {
  description       = "SSH to VPC"
  type              = "egress"
  security_group_id = aws_security_group.ssh.id

  from_port   = var.ssh_port
  to_port     = var.ssh_port
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}

# ---------------------------------------------------------------------------------------------------------------------
# CREATE THE TLS SECURITY GROUP THAT'S APPLIED TO THE EC2 INSTANCE
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_security_group" "tls" {
  name        = "jenkins-agent-tls"
  description = "Security group for nat instances that allows TLS and VPN traffic from/to internet"
  
  lifecycle {
    create_before_destroy = true
  }
}

# Inbound TLS from anywhere
resource "aws_security_group_rule" "allow-tls-inbound" {
  description       = "TLS from VPC"
  type              = "ingress"
  security_group_id = aws_security_group.tls.id

  from_port   = var.tls_port
  to_port     = var.tls_port
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}

# Outbound TLS to anywhere
resource "aws_security_group_rule" "allow-tls-outbound" {
  description       = "TLS to VPC"
  type              = "egress"
  security_group_id = aws_security_group.tls.id

  from_port   = var.tls_port
  to_port     = var.tls_port
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}

# ---------------------------------------------------------------------------------------------------------------------
# CREATE THE HTTP SECURITY GROUP THAT'S APPLIED TO THE EC2 INSTANCE
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_security_group" "http" {
  name        = "jenkins-agent-http"
  description = "Security group for nat instances that allows HTTP and VPN traffic from/to internet"
  
  lifecycle {
    create_before_destroy = true
  }
}

# Inbound HTTP from anywhere
resource "aws_security_group_rule" "allow-http-inbound" {
  description       = "HTTP from VPC"
  type              = "ingress"
  security_group_id = aws_security_group.http.id

  from_port   = var.http_port
  to_port     = var.http_port
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}

# Outbound HTTP to anywhere
resource "aws_security_group_rule" "allow-http-outbound" {
  description       = "HTTP to VPC"
  type              = "egress"
  security_group_id = aws_security_group.http.id

  from_port   = var.http_port
  to_port     = var.http_port
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}
