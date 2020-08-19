resource "random_string" "this_id" {
  length  = 3
  upper   = false
  special = false
}

locals {
  name_identifier = "${var.project}-${lookup(var.short_env, var.env, "noenv")}-${var.identifier}-${random_string.this_id.result}"
}

resource "aws_iam_instance_profile" "instance_profile" {
  count = var.instance_profile == "" ? 1 : 0
  name  = "${local.name_identifier}-instance_profile"
  role  = aws_iam_role.iam_role[0].name
}

resource "aws_iam_role_policy" "iam_role_policy" {
  count = var.instance_profile == "" ? 1 : 0
  name  = "${local.name_identifier}-policy"
  role  = aws_iam_role.iam_role[0].id

  policy = aws_iam_policy.policy[0].policy
}

resource "aws_iam_role" "iam_role" {
  count = var.instance_profile == "" ? 1 : 0
  name  = "${local.name_identifier}-role"
  path  = "/"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
               "Service": "ec2.amazonaws.com"
            },
            "Effect": "Allow",
            "Sid": ""
        }
    ]
}
EOF
}

resource "aws_iam_policy" "policy" {
  count       = var.instance_profile == "" ? 1 : 0
  name        = local.name_identifier
  path        = "/"
  description = "default policy"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "cloudwatchMtric",
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
            "Sid": "cloudwatchLog",
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
            "Resource": [
                "arn:aws:ssm:*:*:parameter/AmazonCloudWatch-*"
            ]
        }
    ]
}
EOF
}

module "ec2_cluster" {
  //  source  = "terraform-aws-modules/ec2-instance/aws"
  source = "git::git@github.com:terraform-aws-modules/terraform-aws-ec2-instance.git?ref=v2.15.0"
  //  version = "~> 2.0"

  name           = local.name_identifier
  instance_count = var.ec2_instance_count

  associate_public_ip_address = var.enable_ec2_public_ip

  disable_api_termination = var.disable_ec2_api_termination
  ami                     = var.ec2_ami_id == "" ? data.aws_ami.ubuntu.id : var.ec2_ami_id
  instance_type           = var.ec2_instance_type
  key_name                = var.ec2_key_name
  monitoring              = true
  vpc_security_group_ids = [
    aws_security_group.security_group.id
  ]

  iam_instance_profile = var.instance_profile == "" ? aws_iam_instance_profile.instance_profile[0].id : var.instance_profile

  subnet_ids = var.ec2_subnet_ids

  user_data = data.template_file.user_data.rendered

  volume_tags = merge(
    var.custom_tags, var.ec2_tags
  )

  tags = merge(
    var.custom_tags, var.ec2_tags
  )
}

# /!\ terraform will not be able to check if your subnet is private or public
resource "aws_eip" "eip" {
  count    = var.enable_eip ? var.ec2_instance_count : 0
  instance = join(", ", element(module.ec2_cluster.*.id, count.index))
  vpc      = true
  tags     = var.custom_tags
}
