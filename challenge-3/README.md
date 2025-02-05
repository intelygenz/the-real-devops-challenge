<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement_terraform) | >=1.0.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_asg"></a> [asg](#module_asg) | ./aws-modules/asg | n/a |
| <a name="module_nlb"></a> [nlb](#module_nlb) | ./aws-modules/nlb | n/a |
| <a name="module_rds"></a> [rds](#module_rds) | ./aws-modules/rds | n/a |
| <a name="module_s3_assets"></a> [s3_assets](#module_s3_assets) | ./aws-modules/s3 | n/a |
| <a name="module_vpc"></a> [vpc](#module_vpc) | ./aws-modules/vpc | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_asg_name"></a> [asg_name](#input_asg_name) | the name of the autoscaling group | `string` | n/a | yes |
| <a name="input_bucket_name"></a> [bucket_name](#input_bucket_name) | Name of the bucket | `string` | n/a | yes |
| <a name="input_cidrs"></a> [cidrs](#input_cidrs) | CIDRs of the VPC | <pre>object({<br>    primary   = string<br>    secondary = optional(list(string))<br>  })</pre> | n/a | yes |
| <a name="input_log_bucket_name"></a> [log_bucket_name](#input_log_bucket_name) | Name of the log bucket | `string` | n/a | yes |
| <a name="input_subnets"></a> [subnets](#input_subnets) | n/a | <pre>map(object({<br>    availability_zones = optional(list(string), ["a", "b", "c"])<br>    cidr_block         = string<br>    IsPrivate          = bool<br>    Isroutable         = bool<br>    subnetName         = optional(string, "")<br>  }))</pre> | n/a | yes |
| <a name="input_target_groups"></a> [target_groups](#input_target_groups) | n/a | <pre>map(object({<br>    name            = optional(string, "nlb-tg")<br>    port            = optional(number, 80)<br>    target_type     = optional(string, "instance")<br>    protocol        = optional(string, "TCP")<br>    health_protocol = optional(string, "TCP")<br>  }))</pre> | n/a | yes |
| <a name="input_region"></a> [region](#input_region) | region to deploy the subnetes | `string` | `"eu-central-1"` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->