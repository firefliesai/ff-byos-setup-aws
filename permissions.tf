resource "aws_iam_role" "byos_object_permissions" {
  name = "firefliesai_aws_byos_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          AWS = "arn:aws:iam::466023587921:root",
        },
        Action = "sts:AssumeRole",
      },
    ],
  })
}

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

resource "aws_iam_role_policy_attachment" "byos_object_permissions_attachment" {
  policy_arn = aws_iam_policy.byos_object_permissions_policy.arn
  role       = aws_iam_role.byos_object_permissions.name
}

resource "aws_iam_role" "bucket_permissions" {
  name = "firefliesai_aws_byos_bucket_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          AWS = "arn:aws:iam::466023587921:root",
        },
        Action = "sts:AssumeRole",
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
          "arn:aws:s3:::${var.bucket_name}",
        ],
      },
    ],
  })
}

resource "aws_iam_role_policy_attachment" "bucket_permissions_attachment" {
  policy_arn = aws_iam_policy.bucket_permissions_policy.arn
  role       = aws_iam_role.bucket_permissions.name
}