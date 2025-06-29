locals {
  function_handler            = "main.handler"
  function_runtime            = "python3.12"
  function_timeout_in_seconds = 5

  function_source_dir = "${path.module}/src/${var.function_name}"
}

resource "aws_lambda_function" "getelement_function" {
  function_name = var.function_name
  timeout       = 5 # seconds
  image_uri = var.image_uri
  package_type  = "Image"

  role = var.arn_lambda_role
  vpc_config {
    security_group_ids = [var.lambda_sg_id]
    subnet_ids         = [var.private_subnet_a, var.private_subnet_b]
  }

  environment {
    variables = {
      DB_HOST     = var.db_host
      DB_PORT     = var.db_port
      DB_NAME     = var.db_name
      DB_USER     = var.db_user
      DB_PASSWORD = var.db_password
    }
  }


}




