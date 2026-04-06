variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "aws_s3_bucket_name" {
  description = "Name of the S3 bucket to store EKS cluster state"
  type        = string
  default     = "my-eks-cluster-state-bucket"
}

variable "dynamodb_table_name" {
  description = "Name of the DynamoDB table for state locking"
  type        = string
  default     = "my-eks-cluster-state-locking"


}

variable "aws_profile" {
  description = "AWS profile to use for authentication"
  type        = string
  default     = "terraform"
}
