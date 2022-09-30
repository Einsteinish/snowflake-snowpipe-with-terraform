terraform {
  backend "s3" {
    bucket = "bogo-sec-test"
    key    = "terraform-state/snowpipe/sample_app_1/terraform.tfstate"
    region = "us-west-2"
  }
}

module "snow_table" {
  source = "../../snowflake-modules/table/"
  app_name              = var.app_name
  events                = var.events
  snowflake_db_name     = var.snowflake_db_name
  snowflake_schema_name = var.snowflake_schema_name

  providers = {
    snowflake.storage_integration_role = snowflake.storage_integration_role
  }
}

module "snow_stage" {
  source = "../../snowflake-modules/stage/"
  app_name                  = var.app_name
  apps_bucket_name          = var.apps_bucket_name
  snowflake_db_name         = var.snowflake_db_name
  snowflake_schema_name     = var.snowflake_schema_name
  event_file_format         = var.event_file_format
  storage_integration_name  = var.storage_integration_name

  providers = {
    snowflake.storage_integration_role = snowflake.storage_integration_role
  }
}

module "snow_pipe" {
  source = "../../snowflake-modules/pipe/"
  depends_on = [module.snow_stage]
  app_name                  = var.app_name
  snowflake_db_name         = var.snowflake_db_name
  snowflake_schema_name     = var.snowflake_schema_name
  events                    = var.events
  event_file_format         = var.event_file_format
  sns_topic_name            = var.sns_topic_name

  providers = {
    snowflake.storage_integration_role = snowflake.storage_integration_role
  }
}





