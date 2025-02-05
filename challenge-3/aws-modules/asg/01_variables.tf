##GLOBAL VARIABLE#

variable "region" {
  type        = string
  default     = "eu-central-1"
  description = "region to deploy the subnetes"
}


variable "cidrs" {
  type        = object({
    primary     = string 
    secondary   = optional(list(string))
  })
  description = "CIDRs of the VPC"
}

variable "subnet_ids" {
  type        = list(string)
  description = "asg subnet ids"
}


variable "vpc_id" {
  type        = string
  description = "the vpc id"
}

variable "asg_name" {
  type        = string
  default     = "el-autoscaling-group"
  description = "the name of the autoscaling group"
}

variable "default_sg" {
  type        = string
  description = "default sg id"
}


variable "private_routable_id" {
  type        = string
  description = "The private route table id"
}

variable "nat_subnet_id" {
  type        = list(string)
  description = "the nat subnet id "
}


