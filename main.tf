data "aws_region" "current" {}
data "aws_caller_identity" "current" {}

resource "aws_s3_bucket" "this" {
  bucket = "codeguru-reviewer-bucket"
}

resource "aws_s3_bucket_lifecycle_configuration" "expire" {
  bucket = aws_s3_bucket.this.bucket

  rule {
    id     = "ExpireRepositoryCode"
    status = "Enabled"
    expiration {
      days = 1
    }
  }
}

resource "aws_s3_bucket_public_access_block" "public_access_block" {
  bucket = aws_s3_bucket.this.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "bucket_encryption" {
  bucket = aws_s3_bucket.this.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}
