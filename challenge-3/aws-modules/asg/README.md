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
| [aws_autoscaling_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_group) | resource |
| [aws_eip.nat](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip) | resource |
| [aws_launch_template.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/launch_template) | resource |
| [aws_nat_gateway.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/nat_gateway) | resource |
| [aws_route.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_instances.asg_instances](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/instances) | data source |
| [aws_security_groups.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/security_groups) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_asg_name"></a> [asg\_name](#input\_asg\_name) | the name of the autoscaling group | `string` | `"el-autoscaling-group"` | no |
| <a name="input_cidrs"></a> [cidrs](#input\_cidrs) | CIDRs of the VPC | <pre>object({<br>    primary     = string <br>    secondary   = optional(list(string))<br>  })</pre> | n/a | yes |
| <a name="input_default_sg"></a> [default\_sg](#input\_default\_sg) | default sg id | `string` | n/a | yes |
| <a name="input_nat_subnet_id"></a> [nat\_subnet\_id](#input\_nat\_subnet\_id) | the nat subnet id | `list(string)` | n/a | yes |
| <a name="input_private_routable_id"></a> [private\_routable\_id](#input\_private\_routable\_id) | The private route table id | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | region to deploy the subnetes | `string` | `"eu-central-1"` | no |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | asg subnet ids | `list(string)` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | the vpc id | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_asg_instances_ids"></a> [asg\_instances\_ids](#output\_asg\_instances\_ids) | The instances ids of the asg |
<!-- END_TF_DOCS -->