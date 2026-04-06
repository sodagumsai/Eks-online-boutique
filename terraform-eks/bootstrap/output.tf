output "s3_bucket_name" {
  value = aws_s3_bucket.boutique_eks_state_bucket.bucket
}

output "dynamodb_table_name" {
  value = aws_dynamodb_table.boutique_eks_state_locking_table.name
}

output "s3_bucket_arn" {
  value = aws_s3_bucket.boutique_eks_state_bucket.arn
}