resource "aws_sns_topic" "sns" {
  name         = "${var.name}"
  display_name = "${var.name}"
}

resource "aws_sns_topic_subscription" "sns" {
  topic_arn = "${aws_sns_topic.sns.arn}"
  protocol  = "lambda"
  endpoint  = "${var.lambda_arn}"
}

resource "aws_lambda_permission" "lambda" {
  statement_id  = "AllowExecutionFromSNS"
  action        = "lambda:InvokeFunction"
  function_name = "${var.lambda_arn}"
  principal     = "sns.amazonaws.com"
  source_arn    = "${aws_sns_topic.sns.arn}"
}
