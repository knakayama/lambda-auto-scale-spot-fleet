output "url" {
  value = "${aws_sqs_queue.queue.id}"
}
