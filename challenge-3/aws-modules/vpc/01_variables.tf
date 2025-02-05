##GLOBAL VARIABLE#

variable "region" {
  type        = string
  default     = "eu-central-1"
  description = "region to deploy the subnetes"
}


#VPC Related Variables#

variable "cidrs" {
  type        = object({
    primary     = string 
    secondary   = optional(list(string))
  })
  description = "CIDRs of the VPC"
}

variable enable_dns_hostnames {
  type        = bool
  default     = true
  description = "Enable DNS hostnames in the VPC"
}

variable enable_dns_support {
  type        = bool
  default     = true
  description = "Enable DNS support in the VPC"
}

variable "subnets" {
    type = map(object({
        availability_zones = optional (list(string),["a","b","c"])
        cidr_block      = string
        IsPrivate         = bool
        Isroutable        = bool
        subnetName        = optional(string,"")
    }))
    description = "VPC subnets"
}

variable "nat_gateway_id" {
  type        = string
  default     = null
  description = "nat gateway id"
}

