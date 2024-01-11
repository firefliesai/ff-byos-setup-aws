# This is a placeholder for the bucket. You are free to edit/change the settings as per your requirements. However, do consult fireflies team before making any changes.

# Please make sure that the cors configuration is applied to the bucket if it is already created. 

resource "aws_s3_bucket" "fireflies-ai-gcp-byos-bucket" {
  bucket = var.bucket_name
}

resource "aws_s3_bucket_cors_configuration" "fireflies-ai-gcp-byos-bucket" {
  bucket = aws_s3_bucket.fireflies-ai-gcp-byos-bucket.id

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["GET", "HEAD", "PUT", "POST", "DELETE"]
    allowed_origins = ["*"]
    max_age_seconds = 3000
  }
}