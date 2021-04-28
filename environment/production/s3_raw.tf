module "ml-ops-s3-raw-data" {
  source = "../../modules/simple_storage_service"
  bucket = "${var.solution_prefix}-${var.account_name}-${var.region}-raw-data"
  acl    = "private"
  versioning = {
    enabled = true
  }
  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        sse_algorithm = "AES256"
      }
    }
  }
  lifecycle_rule = [
    {
      id      = "raw-items-transition"
      enabled = true
      prefix  = "/"
      noncurrent_version_transition = [
        {
          days          = 30
          storage_class = "ONEZONE_IA"
        }
      ]
      noncurrent_version_expiration = {
        days = 90
      }
    }
  ]
}

resource "aws_s3_bucket_object" "ml-ops-s3-object-data-wrangler" {
  bucket = module.ml-ops-s3-raw-data.this_s3_bucket_id
  key = "/data-wrangler/awswrangler-2.7.0-py3-none-any.whl"
  source = "${path.module}/sources/awswrangler-2.7.0-py3-none-any.whl"
}