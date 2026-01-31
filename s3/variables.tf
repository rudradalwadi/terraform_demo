variable "bucket_name" {
  description = "Name of the S3 bucket (must be globally unique)"
  type        = string
}

variable "environment" {
  description = "Environment tag (dev, test, prod)"
  type        = string
  default     = "dev"
}