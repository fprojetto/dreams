resource "aws_apigatewayv2_api" "test_qmee" {
  name          = "test_qmee"
  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_stage" "test_qmee" {
  api_id = aws_apigatewayv2_api.test_qmee.id

  name        = "test_qmee_stage"
  auto_deploy = true

  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.api_gw.arn

    format = jsonencode({
      requestId               = "$context.requestId"
      sourceIp                = "$context.identity.sourceIp"
      requestTime             = "$context.requestTime"
      protocol                = "$context.protocol"
      httpMethod              = "$context.httpMethod"
      resourcePath            = "$context.resourcePath"
      routeKey                = "$context.routeKey"
      status                  = "$context.status"
      responseLength          = "$context.responseLength"
      integrationErrorMessage = "$context.integrationErrorMessage"
    }
    )
  }
}

resource "aws_apigatewayv2_integration" "dreams_api" {
  api_id = aws_apigatewayv2_api.test_qmee.id

  integration_uri    = aws_lambda_function.test_qmee.invoke_arn
  integration_type   = "AWS_PROXY"
  integration_method = "POST"
}

resource "aws_apigatewayv2_route" "dreams" {
  api_id = aws_apigatewayv2_api.test_qmee.id

  route_key = "GET /dreams"
  target    = "integrations/${aws_apigatewayv2_integration.dreams_api.id}"
}

resource "aws_cloudwatch_log_group" "api_gw" {
  name = "/aws/api_gw/${aws_apigatewayv2_api.test_qmee.name}"

  retention_in_days = 30
}

resource "aws_lambda_permission" "api_gw" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.test_qmee.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_apigatewayv2_api.test_qmee.execution_arn}/*/*"
}
