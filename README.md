# terragrunt-aws-generic-ec2

[![Build Status](https://travis-ci.org/bitintheskud/terragrunt-aws-generic-ec2.svg?branch=master)](https://travis-ci.org/bitintheskud/terragrunt-aws-generic-ec2)
[![semantic-release](https://img.shields.io/badge/%20%20%F0%9F%93%A6%F0%9F%9A%80-semantic--release-e10079.svg)](https://github.com/semantic-release/semantic-release)

## Description

Build one or more AWS ec2 instance using terragrunt.

## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| aws | n/a |
| random | n/a |
| template | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| aws\_region | AWS region to create resource in | `string` | n/a | yes |
| bastion\_sg | Bastion security group (required) | `string` | `false` | no |
| bastion\_source\_sg | Bastion source security group id to allow ssh access to host | `string` | `""` | no |
| cloudwatch\_action\_enable | Disable or enable action for cloudwatch alarm | `bool` | n/a | yes |
| cloudwatch\_sns\_topic\_arn | The SNS topic ARN to send cloudwatch alarm | `string` | n/a | yes |
| custom\_tags | Custom tags to add to all the resource | `map(string)` | `{}` | no |
| disable\_ec2\_api\_termination | Disable api termination for ec2 instance. | `bool` | `false` | no |
| ec2\_ami\_id | AMI id to use to create ec2 instances (default to ubuntu) | `string` | `""` | no |
| ec2\_instance\_count | Count of ec2 instance to create | `number` | `1` | no |
| ec2\_instance\_type | ec2 instance type to use. | `string` | `"t3.small"` | no |
| ec2\_key\_name | ec2 key name (must exist) | `string` | n/a | yes |
| ec2\_subnet\_ids | List of subnet ids where ec2 will be created. | `list(string)` | n/a | yes |
| ec2\_tags | Use this variable to add another extra tags to instance in your terragrunt hcl | `any` | `""` | no |
| enable\_bastion | Enable or disable bastion for ssh access | `bool` | `false` | no |
| enable\_ec2\_public\_ip | Associate public ip to the ec2 instance | `bool` | `false` | no |
| enable\_eip | Enable elastic ip creation (static ip) | `bool` | `false` | no |
| enable\_http | Enable or disable http / https | `bool` | `false` | no |
| enable\_route53 | Enable route53 dns creation for your server | `bool` | `true` | no |
| enable\_ssh | Enable or disable ssh access | `bool` | `false` | no |
| env | n/a | `any` | n/a | yes |
| iam\_instance\_profile\_policy | The IAM Instance Profile to launch the instance with. Specified as the name of the Instance Profile. | `string` | n/a | yes |
| identifier | A unique string to describe the role of the resource. This can be for example, front, wp, admin). This is used in the name | `string` | n/a | yes |
| project | Project code will be use to name resource. | `string` | `"infra"` | no |
| route53\_zone\_id | Route53 zone id if dns creation is enable (see enable\_route53) | `string` | n/a | yes |
| security\_group | Security group parameters | `any` | `{}` | no |
| security\_group\_bastion | Bastion security group ID to allow ssh access to host | `string` | `""` | no |
| short\_env | Use to shorten environement in name. Some limit apply sometinmes on res name. | `map` | <pre>{<br>  "development": "dev",<br>  "integration": "int",<br>  "preprod": "pprod",<br>  "preproduction": "pprod",<br>  "production": "prod",<br>  "staging": "stag",<br>  "uat": "uat"<br>}</pre> | no |
| ssh\_cidr\_blocks | Specify cidr block for ssh access to host | `list(string)` | <pre>[<br>  "0.0.0.0/0"<br>]</pre> | no |
| vpc\_id | VPC id to launch the resource in | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| availability\_zone | EC2 availability\_zone as a list |
| dns\_public\_ip | n/a |
| ec2\_eip\_public\_ip | n/a |
| ec2\_private\_dns | n/a |
| ec2\_private\_ip | n/a |
| ec2\_public\_dns | n/a |
| ec2\_public\_ip | n/a |
| instance\_count | EC2 instance count |
| instance\_ids | EC2 instance id as a list |
| security\_group\_id | Security Group id attach to the instance(s) |

