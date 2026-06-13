variable "domain" {
  description = "Root domain name"
  type        = string
  default     = "therossfisher.xyz"
}

variable "bucket_name" {
  description = "S3 bucket name"
  type        = string
  default     = "therossfisher-resume"
}

variable "cloudfront_distribution_id" {
  description = "CloudFront distribution ID"
  type        = string
  default     = "E3B8E628HFB4EI"
}
