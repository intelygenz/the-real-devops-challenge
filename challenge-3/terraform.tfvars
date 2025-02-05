region = "eu-central-1"

#### VPC ####
cidrs = {
  primary   = "172.10.0.0/25"
  secondary = ["172.10.0.128/25"]
}
subnets = {
  public_subnet_1 = {
    availability_zones = ["a"]
    cidr_block         = "172.10.0.0/26"
    IsPrivate          = false
    Isroutable         = true
    subnetName         = "public-subnet-a"
  },
  public_subnet_2 = {
    availability_zones = ["b"]
    cidr_block         = "172.10.0.64/27"
    IsPrivate          = false
    Isroutable         = true
    subnetName         = "public-subnet-b"
  },
  public_subnet_3 = {
    availability_zones = ["c"]
    cidr_block         = "172.10.0.96/27"
    IsPrivate          = false
    Isroutable         = true
    subnetName         = "public-subnet-c"
  },
  private_subnet_1 = {
    availability_zones = ["a"]
    cidr_block         = "172.10.0.128/26"
    IsPrivate          = true
    Isroutable         = true
    subnetName         = "private-subnet-a"
  },
  private_subnet_2 = {
    availability_zones = ["b"]
    cidr_block         = "172.10.0.192/27"
    IsPrivate          = true
    Isroutable         = true
    subnetName         = "private-subnet-b"
  },
  private_subnet_3 = {
    availability_zones = ["c"]
    cidr_block         = "172.10.0.224/27"
    IsPrivate          = true
    Isroutable         = true
    subnetName         = "private-subnet-c"
  }


}

#### ASG ####
asg_name = "el-autoscaling-group"


#### NLB ####
target_groups = {
  tg = {
    name                  = "nlb-tg"
    port                  = 80
    target_type           = "instance"
    protocol              = "TCP"
    health_check_protocol = "TCP"
  }
}


#### S3 ####
bucket_name     = "challenge-assets-bucket"
log_bucket_name = "challenge-logging-bucket"