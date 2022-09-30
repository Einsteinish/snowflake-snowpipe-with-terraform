variable "apps_bucket_name" {
  type    = string
  description = "S3 bucket name, s3://{apps_bucket_name}"
}

variable "app_name" {
  type        = string
  description = "S3 subfolder, app_name is a folder name, i.e., s3://{apps_bucket_name}/{app_name}/"
}

variable "event_file_format" {
  type        = string
  description = "event file format, CSV or JSON"
}

variable "storage_integration_name" {
  type        = string
  description = "storage_integration_name"
}

variable "snowflake_db_name" {
  type        = string
  description = "snowflake db name"
}

variable "snowflake_schema_name" {
  type        = string
  description = "snowflake schema name"
}

locals {
  snowflake_stage_name = upper("STAGE_${var.app_name}")
  snowflake_storage_bucket_url = "s3://${var.apps_bucket_name}/"
}








