resource "aws_cloudwatch_metric_alarm" "ec2_status_check_failed" {
  count               = length(var.cloudwatch_alert_to_enable) > 0 ? var.ec2_instance_count : 0
  actions_enabled     = var.cloudwatch_action_enable
  alarm_name          = "${local.name_identifier}-ec2_status_check_failed-${count.index}"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 2
  metric_name         = "StatusCheckFailed"
  namespace           = "AWS/EC2"
  period              = 300
  statistic           = "Maximum"
  threshold           = 1
  alarm_description   = "EC2 Status Check for instance id: ${module.ec2_cluster.id[count.index]}"
  alarm_actions = [
    var.cloudwatch_sns_topic_arn
  ]
  ok_actions = [
    var.cloudwatch_sns_topic_arn
  ]
  dimensions = { InstanceId = "${module.ec2_cluster.id[count.index]}" }
  tags       = var.custom_tags
}

resource "aws_cloudwatch_metric_alarm" "ec2_high_cpu_usage" {
  count           = contains(var.cloudwatch_alert_to_enable, "cpu") ? var.ec2_instance_count : 0
  actions_enabled = var.cloudwatch_action_enable
  alarm_actions = [
    var.cloudwatch_sns_topic_arn
  ]
  ok_actions = [
    var.cloudwatch_sns_topic_arn
  ]
  alarm_name          = "${local.name_identifier}-ec2_high_cpu_usage-${count.index}"
  comparison_operator = "GreaterThanThreshold"
  datapoints_to_alarm = 1
  dimensions          = { InstanceId = "${module.ec2_cluster.id[count.index]}" }
  evaluation_periods  = 1
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 900
  statistic           = "Average"
  tags                = var.custom_tags
  threshold           = 50
  treat_missing_data  = "missing"
}

resource "aws_cloudwatch_metric_alarm" "ec2_high_memory_usage" {
  count           = contains(var.cloudwatch_alert_to_enable, "memory") ? var.ec2_instance_count : 0
  actions_enabled = var.cloudwatch_action_enable
  alarm_actions = [
    var.cloudwatch_sns_topic_arn
  ]
  ok_actions = [
    var.cloudwatch_sns_topic_arn
  ]
  alarm_name          = "${local.name_identifier}-ec2_high_memory_usage-${count.index}"
  comparison_operator = "GreaterThanThreshold"
  datapoints_to_alarm = 1
  dimensions = {
    "InstanceId"   = "${module.ec2_cluster.id[count.index]}"
    "ImageId"      = var.ec2_ami_id
    "InstanceType" = var.ec2_instance_type
  }
  evaluation_periods = 1
  metric_name        = "mem_used_percent"
  namespace          = "CWAgent"
  period             = 900
  statistic          = "Average"
  tags               = var.custom_tags
  threshold          = 80
  treat_missing_data = "missing"
}

resource "aws_cloudwatch_metric_alarm" "ec2_high_swap_usage" {
  count           = contains(var.cloudwatch_alert_to_enable, "swap") ? var.ec2_instance_count : 0
  actions_enabled = var.cloudwatch_action_enable
  alarm_actions = [
    var.cloudwatch_sns_topic_arn
  ]
  ok_actions = [
    var.cloudwatch_sns_topic_arn
  ]
  alarm_name          = "${local.name_identifier}-ec2_high_swap_usage-${count.index}"
  comparison_operator = "GreaterThanThreshold"
  datapoints_to_alarm = 1
  dimensions = {
    "InstanceId"   = "${module.ec2_cluster.id[count.index]}"
    "ImageId"      = var.ec2_ami_id
    "InstanceType" = var.ec2_instance_type
  }
  evaluation_periods = 1
  metric_name        = "swap_used_percent"
  namespace          = "CWAgent"
  period             = 900
  statistic          = "Average"
  tags               = var.custom_tags
  threshold          = 80
  treat_missing_data = "missing"
}

resource "aws_cloudwatch_metric_alarm" "ec2_high_disk_usage" {
  count           = contains(var.cloudwatch_alert_to_enable, "disk") ? var.ec2_instance_count : 0
  actions_enabled = var.cloudwatch_action_enable
  alarm_actions = [
    var.cloudwatch_sns_topic_arn
  ]
  ok_actions = [
    var.cloudwatch_sns_topic_arn
  ]
  alarm_name          = "${local.name_identifier}-ec2_high_disk_usage-${count.index}"
  comparison_operator = "GreaterThanThreshold"
  datapoints_to_alarm = 1
  dimensions = {
    "InstanceId"   = "${module.ec2_cluster.id[count.index]}"
    "ImageId"      = var.ec2_ami_id
    "device"       = "nvme0n1p1"
    "fstype"       = "ext4"
    "path"         = "/"
    "InstanceType" = var.ec2_instance_type
  }
  evaluation_periods = 1
  metric_name        = "disk_used_percent"
  namespace          = "CWAgent"
  period             = 900
  statistic          = "Average"
  tags               = var.custom_tags
  threshold          = 80
  treat_missing_data = "missing"
}