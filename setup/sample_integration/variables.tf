variable "snowflake_account" {
  type      = string
  sensitive = true
}

variable "prefix" {
  type    = string
  description = "used to name resources"
}

variable "snowflake_storage_integration_owner_role" {
  type    = string
  description = "A role name given by a Snowflake admin"
}

variable "aws_region" {
  type        = string
  description = "The AWS region in which the AWS infrastructure is created."
}

variable "buckets" {
  type        = list(string)
  description = "List of Buckets for the s3_reader role to read from. Used to add S3 buckets to snowflake integration's storage allowed locations."
}

data "aws_caller_identity" "current" {}

locals {
  account_id = data.aws_caller_identity.current.account_id
  prefix  = "${var.prefix}-${var.buckets[0]}"
  data_bucket_arns = [for b in var.buckets: "arn:aws:s3:::${b}" ]
}
