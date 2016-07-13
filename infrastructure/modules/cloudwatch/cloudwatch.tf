resource "aws_cloudwatch_metric_alarm" "scale_out" {
  alarm_name          = "scale_out"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  metric_name         = "ApproximateNumberOfMessagesVisible"
  period              = 300
  namespace           = "AWS/SQS"
  statistic           = "Average"
  threshold           = 100
  alarm_actions       = ["${var.topic_arn}"]

  dimensions {
    QueueName = "${var.name}-queue"
  }
}

resource "aws_cloudwatch_metric_alarm" "scale_in" {
  alarm_name          = "scale_in"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = 1
  metric_name         = "ApproximateNumberOfMessagesVisible"
  period              = 300
  namespace           = "AWS/SQS"
  statistic           = "Average"
  threshold           = 20
  alarm_actions       = ["${var.topic_arn}"]

  dimensions {
    QueueName = "${var.name}-queue"
  }
}
