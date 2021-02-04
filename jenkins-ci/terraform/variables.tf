# ---------------------------------------------------------------------------------------------------------------------
# ENVIRONMENT VARIABLES
# Define these secrets as environment variables
# ---------------------------------------------------------------------------------------------------------------------

# AWS_ACCESS_KEY_ID
# AWS_SECRET_ACCESS_KEY

# ---------------------------------------------------------------------------------------------------------------------
# MANDATORY PARAMETERS
# ---------------------------------------------------------------------------------------------------------------------

variable "ec2_public_key" {
  description = "Path of the file that contains the SSH public key to connect to EC2 instances"
  type        = string
  default     = "/Users/carlostomas/.ssh/aws_ec2_key.pub"
}

variable "ec2_private_key" {
  description = "Path of the file that contains the SSH .pem private key to connect to EC2 instances"
  type        = string
  default     = "/Users/carlostomas/.ssh/aws_ec2_key.pem"
}

variable "worker_public_key" {
  description = "Path of the file that contains the SSH public key of the jenkins worker agents"
  type        = string
  default     = ".ssh/worker_id_rsa.pub"
}

variable "worker_private_key" {
  description = "Path of the file that contains the SSH private key of the jenkins worker agents"
  type        = string
  default     = ".ssh/worker_id_rsa"
}

# variable "jenkins_pwd" {
#   description = "Password of the 'jenkins' user"
#   type        = string
# }

variable "instance_count" {
  description = "Number of EC2 instances"
  type        = number
}

# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# ---------------------------------------------------------------------------------------------------------------------

variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-2" 
}

variable "profile" {
  description = "AWS user profile"
  type        = string
  default     = "terraform" 
}

variable "ami" {
  description = "AWS AMI id"
  type        = string
  default     = "ami-00076cfb64878e76b" # Cloud9 Cloud9Ubuntu AMI
}

variable "instance_type" {
  description = "AWS instance type"
  type        = string
  default     = "t2.small" 
}

variable "ssh_user" {
  description = "The port the server will use for SSH requests"
  type        = string
  default     = "ubuntu"
}

variable "ssh_port" {
  description = "The port the server will use for SSH requests"
  type        = number
  default     = 22
}

variable "tls_port" {
  description = "The port the server will use for TLS requests"
  type        = number
  default     = 443
}

variable "http_port" {
  description = "The port the server will use for HTTP requests"
  type        = number
  default     = 80
}
