module "iam" {
  source = "../modules/iam"
}

module "spot_fleet" {
  source = "../modules/spot_fleet"

  name           = "${var.name}"
  vpc_cidr       = "${var.vpc_cidr}"
  instance_types = "${var.instance_types}"
  spot_prices    = "${var.spot_prices}"
}

module "sqs" {
  source = "../modules/sqs"

  name = "${var.name}"
}

module "tf_sns_email" {
  source = "github.com/deanwilson/tf_sns_email"

  display_name  = "${var.name}"
  email_address = "${var.email_address}"
  owner         = "me"
  stack_name    = "${replace(var.name, "_", "-")}"
}

module "sns" {
  source = "../modules/sns"

  name       = "${var.name}"
  lambda_arn = "${var.apex_function_auto_scale_spot_fleet}"
}

module "cloudwatch" {
  source = "../modules/cloudwatch"

  name      = "${var.name}"
  topic_arn = "${module.sns.arn}"
}
