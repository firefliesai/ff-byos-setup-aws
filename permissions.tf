resource "aws_iam_policy" "byos_object_permissions_policy" {
  name        = "FirefliesAI_BYOS_Object_Permissions"
  description = "Fireflies AI BYOS Object Permissions Policy"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = [
          "s3:PutObject",
          "s3:DeleteObject",
          "s3:GetObject",
          "s3:GetObjectAcl",
          "s3:ListBucket",
          "s3:PutObjectAcl",
        ],
        Resource = [
          "arn:aws:s3:::${var.bucket_name}/*",
        ],
      },
    ],
  })
}



resource "aws_iam_policy" "bucket_permissions_policy" {
  name        = "FirefliesAI_BYOS_Bucket_Permissions"
  description = "Fireflies AI BYOS Bucket Permissions Policy"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = [
          "s3:ListBucket",
          "s3:GetBucketAcl",
          "s3:GetBucketPolicy",
        ],
        Resource = [
          # "arn:aws:s3:::${var.bucket_name}",
          "*",
        ],
      },
    ],
  })
}

resource "aws_iam_role" "bucket_permissions" {
  name = "firefliesai_aws_byos_bucket_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          AWS = [
          "arn:aws:iam::466023587921:root",
          "arn:aws:iam::466023587921:user/rtmp-server-user-0",
         ],
        },
        Action = "sts:AssumeRole",
      },
    ],
  })
}

resource "aws_iam_role_policy_attachment" "bucket_permissions_attachment" {
  policy_arn = aws_iam_policy.bucket_permissions_policy.arn
  role       = aws_iam_role.bucket_permissions.name
}

resource "aws_iam_role_policy_attachment" "byos_object_permissions_attachment" {
  policy_arn = aws_iam_policy.byos_object_permissions_policy.arn
  role       = aws_iam_role.bucket_permissions.name
}

output "role_arn" {
  value = aws_iam_role.bucket_permissions.arn
}

output "bucket_name" {
  value = aws_s3_bucket.fireflies-ai-aws-byos-bucket.id
}

output "bucket_region" {
  value = aws_s3_bucket.fireflies-ai-aws-byos-bucket.region
}
