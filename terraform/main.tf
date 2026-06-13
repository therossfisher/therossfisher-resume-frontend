# S3 bucket for resume site
resource "aws_s3_bucket" "resume" {
  bucket = var.bucket_name
}

# Enable static website hosting
resource "aws_s3_bucket_website_configuration" "resume" {
  bucket = aws_s3_bucket.resume.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "404.html"
  }
}

# Disable block public access
resource "aws_s3_bucket_public_access_block" "resume" {
  bucket = aws_s3_bucket.resume.id

  block_public_acls       = false
  ignore_public_acls      = false
  block_public_policy     = false
  restrict_public_buckets = false
}

# Bucket policy for public read
resource "aws_s3_bucket_policy" "resume" {
  bucket = aws_s3_bucket.resume.id
  depends_on = [aws_s3_bucket_public_access_block.resume]

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Sid       = "PublicReadGetObject"
      Effect    = "Allow"
      Principal = "*"
      Action    = "s3:GetObject"
      Resource  = "${aws_s3_bucket.resume.arn}/*"
    }]
  })
}

# Route53 hosted zone
resource "aws_route53_zone" "main" {
  name = var.domain
}

# A record pointing to CloudFront
resource "aws_route53_record" "root" {
  zone_id = aws_route53_zone.main.zone_id
  name    = var.domain
  type    = "A"

  alias {
    name                   = "d2t0kfvtum0px.cloudfront.net"
    zone_id                = "Z2FDTNDATAQYW2"
    evaluate_target_health = false
  }
}

# Dashboard CNAME
resource "aws_route53_record" "dashboard" {
  zone_id = aws_route53_zone.main.zone_id
  name    = "dashboard.${var.domain}"
  type    = "CNAME"
  ttl     = 300
  records = ["therossfisher.github.io"]
}

# ACM validation record
resource "aws_route53_record" "acm_validation" {
  zone_id = aws_route53_zone.main.zone_id
  name    = "_6d5e00e7ad67f3f78408d1e9d91a0f7c.${var.domain}"
  type    = "CNAME"
  ttl     = 300
  records = ["_cb9264a8e425cab8cc375cceb5e7c78c.jkddzztszm.acm-validations.aws."]
}
