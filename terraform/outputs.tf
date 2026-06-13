output "bucket_name" {
  value = aws_s3_bucket.resume.id
}

output "website_endpoint" {
  value = aws_s3_bucket_website_configuration.resume.website_endpoint
}

output "nameservers" {
  value = aws_route53_zone.main.name_servers
}
