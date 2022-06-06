resource "aws_lambda_function" "test_qmee" {
  function_name = "test-qmee"
  role          = aws_iam_role.lambda_exec.arn

  s3_bucket = aws_s3_bucket.dreams_artifacts.bucket
  s3_key = aws_s3_object.artifact.key

  runtime          = "nodejs16.x"
  handler          = "dreams.handler"

  source_code_hash = data.archive_file.artifact.output_base64sha256
}

resource "aws_iam_role" "lambda_exec" {
  name = "serverless_lambda"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Sid    = ""
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_policy_basic" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_cloudwatch_log_group" "test_qmee" {
  name              = "/aws/lambda/${aws_lambda_function.test_qmee.function_name}"
  retention_in_days = 7
}
