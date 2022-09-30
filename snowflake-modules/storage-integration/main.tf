locals {
  pipeline_bucket_ids = [
    for bucket_arn in var.data_bucket_arns : element(split(":::", bucket_arn), 1)
  ]
  storage_provider = length(regexall(".*gov.*", local.aws_region)) > 0 ? "s3gov" : "S3" # uppercase
}

resource "snowflake_storage_integration" "this" {
  provider = snowflake.storage_integration_role

  name    = "${upper(replace(var.prefix, "-", "_"))}_STORAGE_INTEGRATION"
  type    = "EXTERNAL_STAGE"
  enabled = true
  storage_allowed_locations = concat(
    # ["${local.storage_provider}://${data.aws_s3_bucket.snowpipe_bucket.id}/"],
    [for bucket_id in local.pipeline_bucket_ids : "s3://${bucket_id}/"]
  )
  storage_provider     = local.storage_provider
  storage_aws_role_arn = "arn:aws:iam::${local.account_id}:role/${local.s3_reader_role_name}"
}



