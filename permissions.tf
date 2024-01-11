resource "aws_iam_policy" "ff-byos-object_policy" {
  name        = "ff-byos-object_policy"
  description = "Fireflies AI BYOS Policy"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "s3:GetObject",
          "s3:ListBucket",
          "s3:PutObject",
          "s3:DeleteObject",
          "s3:UpdateObject",
          "s3:GetObjectAcl",
        ],
        Resource = [
          "arn:aws:s3:::var.bucket_name/*",
          "arn:aws:s3:::var.bucket_name",
        ],
      },
    ],
  })
}

resource "aws_iam_policy_attachment" "ff-byos-object_policy_attachment" {
  name       = "ff-byos-object_policy_attachment"
  roles      = ["arn:aws:iam::account-id:role/ff-byos"]
  policy_arn = aws_iam_policy.ff-byos-object_policy.arn
}

resource "aws_iam_policy" "ff-byos-bucket_policy" {
  name        = "ff-byos-bucket_policy"
  description = "Fireflies AI BYOS Bucket Policy"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "s3:ListBucket",
          "s3:GetBucketLocation",
          "s3:GetBucketAcl",
          "s3:PutBucketAcl",
        ],
        Resource = "arn:aws:s3:::var.bucket_name",
      },
    ],
  })
}

resource "aws_iam_policy_attachment" "ff-byos-bucket_policy_attachment" {
  name       = "ff-byos-bucket_policy_attachment"
  roles      = ["arn:aws:iam::account-id:role/ff-byos"]
  policy_arn = aws_iam_policy.ff-byos-bucket_policy.arn
}