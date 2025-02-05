##GLOBAL VARIABLE#

variable "region" {
  type        = string
  default     = "eu-central-1"
  description = "region to deploy the subnetes"
}

variable "subnet_ids" {
  type        = list(string)
  description = "asg subnet ids"
}

variable "vpc_id" {
  type        = string
  description = "the vpc id"
}

variable "internal" {
  type        = bool
  description = "True mean internal-facing lb , False means Internet-facing lb"
}


variable "target_groups" {
    type = map(object({
        name = optional(string,"nlb-tg")
        port = optional(number,80)
        target_type = optional(string,"instance")
        protocol = optional(string,"TCP")
        health_protocol = optional(string,"TCP")
    }))
    description = "Load balancers target groups that aim for the resources"
}

variable "cidrs" {
  type = object({
    primary   = string
    secondary = optional(list(string))
  })
  description = "CIDRs of the VPC"
}

variable "asg_name" {
  type        = string
  default     = "el-autoscaling-group"
  description = "the name of the autoscaling group"
}

variable "instances_ids" {
  type        = list(string)
  description = "instance ids for the nlb target group"
}


variable "default_sg" {
  type        = string
  description = "default sg id"
}
