resource "aws_sqs_queue" "queue" {
  name                      = "${var.name}-queue"
  delay_seconds             = 0
  max_message_size          = 2048
  message_retention_seconds = 86400
  receive_wait_time_seconds = 0
}
