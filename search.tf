resource "aws_s3_bucket_policy" "fireflies-ai-aws-byos-bucket" {
  bucket = aws_s3_bucket.fireflies-ai-aws-byos-bucket.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid       = "TurbopufferPrivateSearchBucket",
        Effect    = "Allow",
        Principal = { AWS = "arn:aws:iam::961341552108:role/turbopuffer-fireflies-aws-us-east-1-kube-node" },
        Action    = ["s3:ListBucket"],
        Resource  = aws_s3_bucket.fireflies-ai-aws-byos-bucket.arn,
        Condition = { StringLike = { "s3:prefix" = ["tpuf", "tpuf/*"] } },
      },
      {
        Sid       = "TurbopufferPrivateSearchObjects",
        Effect    = "Allow",
        Principal = { AWS = "arn:aws:iam::961341552108:role/turbopuffer-fireflies-aws-us-east-1-kube-node" },
        Action    = ["s3:GetObject", "s3:PutObject", "s3:DeleteObject"],
        Resource  = "${aws_s3_bucket.fireflies-ai-aws-byos-bucket.arn}/tpuf/*",
      },
    ],
  })
}
