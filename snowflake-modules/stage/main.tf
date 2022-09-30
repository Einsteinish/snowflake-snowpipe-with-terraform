resource "snowflake_stage" "this" {
    provider = snowflake.storage_integration_role
    name        = local.snowflake_stage_name
    url         = local.snowflake_storage_bucket_url
    database    = var.snowflake_db_name
    schema      = var.snowflake_schema_name
    file_format = "type = ${var.event_file_format}"
    storage_integration = var.storage_integration_name
}