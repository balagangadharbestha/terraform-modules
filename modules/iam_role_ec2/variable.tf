variable "role_name" {
  description = "IAM role name"
  type        = string
}

variable "bucket_name" {
  description = "Specific S3 bucket to allow access to"
  type        = string
}

variable "aws_iam_instance_profile" {
  description = "IAM instance profile to attach to the EC2 instance"
  type        = string
  default     = null
}