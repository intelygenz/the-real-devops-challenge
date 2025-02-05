variable "region" {
  type        = string
  default     = "eu-central-1"
  description = "region to deploy the subnetes"
}

variable "cidrs" {
  type = object({
    primary   = string
    secondary = optional(list(string))
  })
  description = "CIDRs of the VPC"
}
variable "subnets" {
  type = map(object({
    availability_zones = optional(list(string), ["a", "b", "c"])
    cidr_block         = string
    IsPrivate          = bool
    Isroutable         = bool
    subnetName         = optional(string, "")
  }))
}

variable "target_groups" {
  type = map(object({
    name            = optional(string, "nlb-tg")
    port            = optional(number, 80)
    target_type     = optional(string, "instance")
    protocol        = optional(string, "TCP")
    health_protocol = optional(string, "TCP")
  }))
}

variable "asg_name" {
  type        = string
  description = "the name of the autoscaling group"
}


#### S3 ####

variable "bucket_name" {
  type        = string
  description = "Name of the bucket"
}

variable "log_bucket_name" {
  type        = string
  description = "Name of the log bucket"
}
