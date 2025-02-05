<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_db_instance.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance) | resource |
| [aws_db_subnet_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_subnet_group) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cidrs"></a> [cidrs](#input\_cidrs) | CIDRs of the VPC | <pre>object({<br>    primary   = string<br>    secondary = optional(list(string))<br>  })</pre> | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | region to deploy the subnetes | `string` | `"eu-central-1"` | no |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | asg subnet ids | `list(string)` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | the vpc id | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->