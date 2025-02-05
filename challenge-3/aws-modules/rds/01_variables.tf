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
variable "cidrs" {
  type = object({
    primary   = string
    secondary = optional(list(string))
  })
  description = "CIDRs of the VPC"
}