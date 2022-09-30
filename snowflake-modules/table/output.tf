output "snowflake_table_name" {
  description = "Names of snowflake table"
  value       = values(snowflake_table.this)[*].name
}