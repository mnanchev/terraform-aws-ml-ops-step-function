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