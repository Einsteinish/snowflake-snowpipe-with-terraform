output "snowflake_pipe_name" {
  description = "Names of snowflake pipe"
  value       = values(snowflake_pipe.this)[*].name
}