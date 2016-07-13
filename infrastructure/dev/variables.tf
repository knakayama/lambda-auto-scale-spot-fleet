variable "aws_region" {}

variable "apex_function_auto_scale_spot_fleet" {}

variable "name" {
  default = "auto_scale_spot_fleet"
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "instance_types" {
  default = {
    m3_medium = "m3.medium"
    m3_large  = "m3.large"
  }
}

variable "spot_prices" {
  default = {
    max       = "0.1"
    m3_medium = "0.05"
    m3_large  = "0.06"
  }
}

variable "email_address" {
  default = "_YOUR_EMAIL_ADDRESS_HERE_"
}
