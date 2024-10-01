resource "aws_s3_bucket" "frontend" {
  bucket = var.bucket_name

  website {
    index_document = "index.html"
    error_document = "error.html"
  }

  tags = {
    Name = var.bucket_tag_name
    Environment = var.bucket_tag_env
  }
}

resource "aws_s3_bucket_ownership_controls" "name" {
  bucket = aws_s3_bucket.frontend.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
  depends_on = [ aws_s3_bucket_public_access_block.example ]
}

resource "aws_s3_bucket_public_access_block" "example" {
  bucket = aws_s3_bucket.frontend.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "bucket-policy" {
  bucket = aws_s3_bucket.frontend.id
  policy = data.aws_iam_policy_document.iam-policy-1.json
}
data "aws_iam_policy_document" "iam-policy-1" {
  statement {
    sid    = "AllowPublicRead"
    effect = "Allow"
resources = [
      "${aws_s3_bucket.frontend.arn}/*"
    ]
actions = ["S3:GetObject"]
principals {
      type        = "*"
      identifiers = ["*"]
    }
  }

  depends_on = [aws_s3_bucket_public_access_block.example]
}

resource "aws_s3_bucket_object" "index_html" {
  bucket = aws_s3_bucket.frontend.bucket
  key    = "index.html"
  source = var.main_website_path
  content_type = "text/html"
}

resource "aws_s3_bucket_object" "error_html" {
  bucket = aws_s3_bucket.frontend.bucket
  key    = "error.html"
  source = var.error_website_path
  content_type = "text/html"
}

resource "aws_s3_bucket_website_configuration" "website-config" {
  bucket = aws_s3_bucket.frontend.bucket
index_document {
    suffix = "index.html"
  }
error_document {
    key = "error.html"
  }
}

output "website_url" {
  value = aws_s3_bucket.frontend.website_endpoint
}

output "website_domain" {
  value = aws_s3_bucket.frontend.website_domain
}

output "website_hosted_zone_id" {
  value = aws_s3_bucket.frontend.hosted_zone_id
}