resource "aws_s3_bucket" "S3_webpub_bucket" {
  bucket = var.bucket_name
  tags = {
    Name = var.bucket_name
    Environment= var.environment
  }
  lifecycle {
    prevent_destroy = true
  }
}

# associate iam role with ec2 instance
resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = "${terraform.workspace}_ec2_instance_profile"
  role = basename(var.ec2_iam_role_arn)
}

resource "aws_s3_bucket_policy" "s3_policy" {
  bucket = aws_s3_bucket.S3_webpub_bucket.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          AWS = var.ec2_iam_role_arn
        }
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:ListBucket"
        ]
        Resource = [
          aws_s3_bucket.S3_webpub_bucket.arn,
          "${aws_s3_bucket.S3_webpub_bucket.arn}/*"
        ]
      }
    ]
  })
}