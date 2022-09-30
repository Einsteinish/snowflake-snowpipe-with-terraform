variable "app_name" {
  type        = string
  description = "S3 subfolder, app_name is a folder name, i.e., s3://{apps_bucket_name}/{app_name}/"
}

variable "events" {
  type        = list
  description = "event types, this is a sub-folder name, i.e., s3://{apps_bucket_name}/{app_name}/{events}/"
}

variable "snowflake_db_name" {
  type        = string
  description = "snowflake db name"
}

variable "snowflake_schema_name" {
  type        = string
  description = "snowflake schema name"
}

variable "event_file_format" {
  type        = string
  default     = "JSON"
  description = "event file format, CSV or JSON"
}

variable "sns_topic_name" {
  type        = string
  description = "sns_topic_name"
}

locals {
  snowflake_stage_name = upper("STAGE_${var.app_name}")
}









