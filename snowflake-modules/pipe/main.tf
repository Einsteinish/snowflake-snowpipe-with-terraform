# pipes 
resource "snowflake_pipe" "this" {
  database          = var.snowflake_db_name
  schema            = var.snowflake_schema_name
  for_each          = toset(var.events)
  name              = upper("pipe_${var.app_name}_${each.value}")
  comment           = "A pipe to ingest the incoming apps - item_usages."

  copy_statement    = <<EOT
    COPY INTO ${var.snowflake_db_name}.${var.snowflake_schema_name}.${var.app_name}_${each.value} (UUID, EVENT_TS,  RAW)
        FROM (
        SELECT 
          uuid_string(),
			    current_timestamp(),
			    T.$1 
          FROM @${var.snowflake_db_name}.${var.snowflake_schema_name}.${local.snowflake_stage_name}/${var.app_name}/${each.value} T
        )
        file_format = (type=${var.event_file_format})
    EOT

  auto_ingest       = true

  aws_sns_topic_arn = data.aws_sns_topic.current.arn
}

data "aws_sns_topic" "current" {
  name = var.sns_topic_name
}
