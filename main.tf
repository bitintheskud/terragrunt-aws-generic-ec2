resource "random_string" "this_id" {
  length  = 3
  upper   = false
  special = false
}

locals {
  name_identifier = "${var.project}-${lookup(var.short_env, var.env, "noenv")}-${var.identifier}-${random_string.this_id.result}"
}

module "ec2_cluster" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 2.0"

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
