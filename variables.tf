variable "env" {}

variable "aws_region" {
  type        = string
  default     = "eu-west-1"
  description = "AWS region to create resource in"
}

variable "custom_tags" {
  type        = map(string)
  default     = {}
  description = "Custom tags to add to all the resource"
}

variable "project" {
  type        = string
  default     = "infra"
  description = "Project code will be use to name resource."
}

variable "identifier" {
  type        = string
  description = "A unique string to describe the role of the resource. This can be for example, front, wp, admin). This is used in the name"
}

variable "vpc_id" {
  type        = string
  description = "VPC id to launch the resource in"
}

variable "enable_eip" {
  type        = bool
  description = "Enable elastic ip creation (static ip)"
  default     = false
}

variable "enable_route53" {
  type        = bool
  description = "Enable route53 dns creation for your server"
  default     = true
}

variable "route53_zone_id" {
  type        = string
  description = "Route53 zone id if dns creation is enable (see enable_route53)"
}
variable "bastion_sg" {
  type        = string
  description = "Bastion security group (required)"
  default     = false
}

variable "enable_bastion" {
  type        = bool
  description = "Enable or disable bastion for ssh access"
  default     = false
}

variable "bastion_source_sg" {
  type        = string
  description = "Bastion source security group id to allow ssh access to host"
  default     = ""
}

variable "security_group_bastion" {
  type        = string
  description = "Bastion security group ID to allow ssh access to host"
  default     = ""
}

variable "enable_ssh" {
  type        = bool
  description = "Enable or disable ssh access"
  default     = false
}

variable "ssh_cidr_blocks" {
  type        = list(string)
  description = "Specify cidr block for ssh access to host"
  default     = ["0.0.0.0/0"]
}

variable "ec2_instance_count" {
  type        = number
  description = "Count of ec2 instance to create"
  default     = 1
}

variable "ec2_instance_type" {
  type        = string
  description = "ec2 instance type to use."
  default     = "t3.small"
}

variable "ec2_key_name" {
  type        = string
  description = "ec2 key name (must exist)"
}

variable "enable_ec2_public_ip" {
  type        = bool
  description = "Associate public ip to the ec2 instance"
  default     = false
}

variable "disable_ec2_api_termination" {
  type        = bool
  description = "Disable api termination for ec2 instance."
  default     = false
}

variable "ec2_tags" {
  type        = any
  description = "Use this variable to add another extra tags to instance in your terragrunt hcl"
  default     = ""
}

variable "ec2_subnet_ids" {
  type        = list(string)
  description = "List of subnet ids where ec2 will be created."
}

variable "ec2_ami_id" {
  type        = string
  description = "AMI id to use to create ec2 instances (default to ubuntu)"
  default     = ""
}

variable "short_env" {
  type = map
  default = {
    development   = "dev"
    production    = "prod"
    staging       = "stag"
    integration   = "int"
    uat           = "uat"
    preproduction = "pprod"
    preprod       = "pprod"
  }
  description = "Use to shorten environement in name. Some limit apply sometinmes on res name."
}

variable "security_group" {
  type        = any
  default     = {}
  description = "Security group parameters"
}
