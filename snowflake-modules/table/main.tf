# tables
resource "snowflake_table" "this" {   
  database      = var.snowflake_db_name
  schema        = var.snowflake_schema_name
  for_each      = toset(var.events)
  name = upper("${var.app_name}_${each.value}")
  comment             = "app tables"

  column {
    name     = "UUID"
    type     = "varchar(36)" 
    nullable = false
  }
  
  column {
    name     = "EVENT_TS"
    type     = "TIMESTAMP_NTZ(9)"
    nullable = false
  }
  
  column {
    name    = "RAW"
    type    = "VARIANT"
    nullable = false
    comment = "Raw data"
  }
}
