terraform {
  backend "s3" {
    bucket = "bogo-sec-test"
    key    = "terraform-state/snowpipe/integrations/sample_integration/terraform.tfstate"
    region = "us-west-2"
  }
}

module "storage_integration" {
  source = "../../snowflake-modules/storage-integration/"

  prefix = local.prefix
  data_bucket_arns = local.data_bucket_arns

  providers = {
    snowflake.storage_integration_role = snowflake.storage_integration_role
    aws                                = aws
  }
}

data "snowflake_storage_integrations" "current" {
}