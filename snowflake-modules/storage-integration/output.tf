output "storage_integration_name" {
  description = "Name of Storage integration"
  value       = snowflake_storage_integration.this.name
}

output "storage_integration" {
  description = "Storage integration"
  value       = snowflake_storage_integration.this
}

output "bucket_arn" {
  description = "Snowflake allowed S3 Bucket ARN"
  value        = var.data_bucket_arns
}

output "sns_topic_arn" {
  description = "SNOWPIPE S3 SNS Topic to use while creating the Snowflake PIPE."
  value       = aws_sns_topic.snowpipe_bucket_sns.arn
}

output "s3_pipline_bucket_notification" {
  description = "s3_bucket_notification."
  value       = aws_s3_bucket_notification.snowpipe_s3_pipline_bucket_notification
}

output "snowflake_role" {
  description = "snowflake_role to access s3."
  value       = aws_iam_role.s3_reader
}

output "s3_reader_policy" {
  description = "s3_reader_policy"
  value       = aws_iam_role_policy.s3_reader
}


