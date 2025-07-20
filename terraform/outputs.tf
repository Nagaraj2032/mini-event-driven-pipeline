# terraform/outputs.tf

output "s3_bucket_name" {
  value = aws_s3_bucket.input_bucket.bucket
}

output "dynamodb_table_name" {
  value = aws_dynamodb_table.processed_data.name
}
