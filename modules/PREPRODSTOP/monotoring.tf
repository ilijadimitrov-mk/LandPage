data "aws_region" "current" {}

resource "aws_cloudwatch_metric_alarm" "recover_ec2" {
  # Metric
  namespace   = "AWS/EC2"
  metric_name = "StatusCheckFailed_System"
  dimensions = {
    InstanceId = aws_instance.preprod_instance.id # output of the instance id created
  }
  statistic = "Minimum"
  period    = "60"
  unit      = "Count"
  # Conditions
  threshold           = "1"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  # additional configuration
  evaluation_periods = "2"
  treat_missing_data = "missing"
  # Notification
  #ok_actions                = var.aws_sns_topic_arn
  alarm_actions = ["arn:aws:automate:${data.aws_region.current.name}:ec2:recover"]

  # Name and Description
  alarm_name        = "Recover EC2 Instance with Tag Name: ${var.instance_name} and ID: ${aws_instance.preprod_instance.id}"
  alarm_description = "Recover EC2 instance when health checks fail"
  tags = merge(
    { Name = "Recover EC2 Instance with Tag Name: ${var.instance_name} and ID: ${aws_instance.preprod_instance.id}" }
  )
}

