output "storage_integration_name" {
  description = "Name of Storage integration"
  value       = module.storage_integration.storage_integration_name
}

output "bucket_arns" {
  description = "S3 Bucket URL"
  value       = module.storage_integration.bucket_arn
}

output "sns_topic_arn" {
  description = "SNS Topic to use while creating the Snowflake PIPE."
  value       = module.storage_integration.sns_topic_arn
}

output "snowflake_role_for_s3" {
  description = "snowflake_role name to access s3."
  value       = module.storage_integration.snowflake_role.name
}

output "terraform_workspace" {
  description = "default/dev/prod: can be set via 'terraform workspace' cmd"
  value = terraform.workspace
}