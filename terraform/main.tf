# Generate a random suffix to avoid S3 bucket name conflicts
resource "random_id" "suffix" {
  byte_length = 4
}

# S3 Bucket to receive uploaded files
resource "aws_s3_bucket" "input_bucket" {
  bucket        = "mini-pipeline-input-${random_id.suffix.hex}"
  force_destroy = true
  tags = {
    Name        = "InputBucket"
    Environment = "Dev"
  }
}

# DynamoDB Table to store processed data
resource "aws_dynamodb_table" "processed_data" {
  name         = "processed-data"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "id"

  attribute {
    name = "id"
    type = "S"
  }

  tags = {
    Name        = "ProcessedDataTable"
    Environment = "Dev"
  }
}

# Archive the Lambda function
data "archive_file" "lambda_zip" {
  type        = "zip"
  source_file = "${path.module}/../lambda/lambda_function.py"
  output_path = "${path.module}/function.zip"
}

# IAM Role for Lambda execution
resource "aws_iam_role" "lambda_exec_role" {
  name = "lambda_exec_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action    = "sts:AssumeRole",
      Effect    = "Allow",
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })
}

# Attach basic Lambda execution policy
resource "aws_iam_role_policy_attachment" "lambda_basic_execution" {
  role       = aws_iam_role.lambda_exec_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# Create IAM Policy for Lambda to write to DynamoDB
resource "aws_iam_policy" "dynamodb_access" {
  name = "lambda_dynamodb_policy"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect   = "Allow",
      Action   = ["dynamodb:PutItem"],
      Resource = aws_dynamodb_table.processed_data.arn
    }]
  })
}

# Attach custom DynamoDB access policy to Lambda role
resource "aws_iam_policy_attachment" "lambda_dynamodb_attach" {
  name       = "lambda_dynamodb_attachment"
  policy_arn = aws_iam_policy.dynamodb_access.arn
  roles      = [aws_iam_role.lambda_exec_role.name]
}

# Create Lambda function
resource "aws_lambda_function" "s3_processor" {
  filename         = "${path.module}/function.zip"
  function_name    = "s3FileProcessor"
  role             = aws_iam_role.lambda_exec_role.arn
  handler          = "lambda_function.lambda_handler"
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256
  runtime          = "python3.9"
  timeout          = 10
}

# Give S3 permission to invoke Lambda
resource "aws_lambda_permission" "allow_s3" {
  statement_id  = "AllowS3Invoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.s3_processor.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.input_bucket.arn
}

# Configure S3 bucket to trigger Lambda on object creation
resource "aws_s3_bucket_notification" "s3_event" {
  bucket = aws_s3_bucket.input_bucket.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.s3_processor.arn
    events              = ["s3:ObjectCreated:*"]
  }

  depends_on = [aws_lambda_permission.allow_s3]
}
