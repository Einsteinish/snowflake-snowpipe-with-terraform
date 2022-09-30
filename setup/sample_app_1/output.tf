
output "snowflake_table_names" {
  description = "snowflake table names"
  value         = module.snow_table.snowflake_table_name
}

output "snowflake_stage_name" {
  description = "snowflake stage name"
  value         = module.snow_stage.snowflake_stage_name
}

output "snowflake_pipe_names" {
  description = "snowflake pipe names"
  value         = module.snow_pipe.snowflake_pipe_name
}

output "terraform_workspace" {
  description = "default/dev/prod: can be set via 'terraform workspace' cmd"
  value = terraform.workspace
}


