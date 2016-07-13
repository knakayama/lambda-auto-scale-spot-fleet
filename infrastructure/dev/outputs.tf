output "lambda_function_role_id" {
  value = "${module.iam.lambda_function_role_id}"
}

output "spot_fleet_id" {
  value = "${module.spot_fleet.spot_fleet_id}"
}

output "spot_fleet_request_state" {
  value = "${module.spot_fleet.spot_fleet_request_state}"
}

output "queue_url" {
  value = "${module.sqs.url}"
}

output "topic_for_notify_arn" {
  value = "${module.tf_sns_email.arn}"
}

output "topic_for_invoke_arn" {
  value = "${module.sns.arn}"
}
