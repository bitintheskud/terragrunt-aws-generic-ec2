include {
  path = "${find_in_parent_folders()}"
}

terraform {
  source = "github.com/bitintheskud/terragrunt-aws-generic-ec2?ref=v1.2.0"
}

dependency "bastion" {
  config_path = "../ec2-bastion"
}

dependency "vpc" {
  config_path = "../vpc"
}

dependency "keypair" {
  config_path = "../keypair-lbc"
}

dependency "sns" {
  config_path = "../sns-cw-alerts"
}

locals {
  aws_region              = basename(dirname(get_terragrunt_dir()))
  project                 = "my_project"
  role                    = "webserver"
  identifier              = "drupal"
  env                     = "production"
  key_name                = "my_key"
  custom_tags             = yamldecode(file("${find_in_parent_folders("custom_tags.yaml")}"))
  instance_type           = "t3.small"
  zone_id                 = "Z1O9CTKAB6HWQ"
  ssh_cidr_blocks         = ["10.0.0.0/16"]
  disable_api_termination = false
  ec2_ami_id              = "ami-0r98re9f43fd61af1b0c"
}


inputs = {
  ssh_cidr_blocks          = local.ssh_cidr_blocks
  enable_route53           = false
  enable_eip               = false
  aws_region               = local.aws_region
  route53_zone_id          = local.zone_id
  enable_bastion           = true
  bastion_source_sg        = dependency.bastion.outputs.security_group_id
  project                  = local.project
  aws_region               = local.aws_region
  identifier               = local.identifier
  custom_tags              = local.custom_tags
  env                      = local.env
  vpc_id                   = dependency.vpc.outputs.vpc_id
  enable_http              = 1
  enable_https             = 1
  cloudwatch_sns_topic_arn = dependency.sns.outputs.sns_topic_arn
  cloudwatch_action_enable = true
  ec2_ami_id               = local.ec2_ami_id
  ec2_key_name             = dependency.keypair.outputs.key_pair_name
  ec2_instance_type        = local.instance_type
  ec2_subnet_ids           = dependency.vpc.outputs.private_subnet_ids
  ec2_tags = {
    "Role" = local.role
  }
  iam_instance_profile_policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "cloudwatch:PutMetricData",
                "ec2:DescribeTags",
                "cloudwatch:GetMetricStatistics",
                "cloudwatch:ListMetrics"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "s3:Get*",
                "s3:List*"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "ec2:DescribeVolumes",
                "logs:PutLogEvents",
                "logs:DescribeLogStreams",
                "logs:DescribeLogGroups",
                "logs:CreateLogStream",
                "logs:CreateLogGroup"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "ssm:GetParameter"
            ],
            "Resource": "arn:aws:ssm:*:*:parameter/AmazonCloudWatch-*"
        }
    ]
}
POLICY
}
