data "archive_file" "app-lambda" {
  type = "zip"
  source_dir = var.function_source_dir
  output_path = "${var.function_source_dir}/${var.function_name}.zip"
  excludes = [
    "${var.function_source_dir}/${var.function_name}.zip"]
}

resource "aws_lambda_function" "app-lambda" {
  filename = data.archive_file.app-lambda.output_path
  function_name = var.function_name
  role = aws_iam_role.lambda-function-role.arn
  handler = var.function_handler
  source_code_hash = data.archive_file.app-lambda.output_base64sha256
  runtime = "nodejs12.x"
  #environment {}
  depends_on = [
    data.archive_file.app-lambda,
    aws_iam_role.lambda-function-role
  ]
}

resource "aws_api_gateway_rest_api" "app-lambda-ra" {
  name = "${var.function_name}_api"
}

resource "aws_api_gateway_resource" "app-lambda-resource" {
  path_part = var.function_name
  parent_id = aws_api_gateway_rest_api.app-lambda-ra.root_resource_id
  rest_api_id = aws_api_gateway_rest_api.app-lambda-ra.id
}

resource "aws_api_gateway_method" "app-lambda-method" {
  rest_api_id = aws_api_gateway_rest_api.app-lambda-ra.id
  resource_id = aws_api_gateway_resource.app-lambda-resource.id
  http_method = "ANY"
  authorization = "NONE"
}


resource "aws_api_gateway_integration" "app-lambda-gi" {
  rest_api_id = aws_api_gateway_rest_api.app-lambda-ra.id
  resource_id = aws_api_gateway_resource.app-lambda-resource.id
  http_method = aws_api_gateway_method.app-lambda-method.http_method
  integration_http_method = "POST"
  type = "AWS_PROXY"
  uri = aws_lambda_function.app-lambda.invoke_arn
}


resource "aws_api_gateway_deployment" "app-lambda-deployment" {
  depends_on = [
    aws_api_gateway_integration.app-lambda-gi]
  stage_name = var.api_gateway_stage
  rest_api_id = aws_api_gateway_rest_api.app-lambda-ra.id
}

resource "aws_lambda_permission" "api-gw" {
  statement_id = "AllowAPIGatewayInvoke"
  action = "lambda:InvokeFunction"
  function_name = aws_lambda_function.app-lambda.function_name
  principal = "apigateway.amazonaws.com"
  source_arn = "${aws_api_gateway_rest_api.app-lambda-ra.execution_arn}/${var.api_gateway_stage}/${aws_api_gateway_method.app-lambda-method.http_method}/${aws_api_gateway_resource.app-lambda-resource.path_part}"
}
