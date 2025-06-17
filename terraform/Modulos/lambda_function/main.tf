locals {
  function_name               = "src"
  function_handler            = "getelement.handler"
  function_runtime            = "python3.9"
  function_timeout_in_seconds = 5

  function_source_dir = "${path.module}/${local.function_name}"
}

resource "aws_lambda_function" "getelement_function" {
  function_name = "${local.function_name}"
  handler       = local.function_handler
  runtime       = local.function_runtime
  timeout       = local.function_timeout_in_seconds

  filename         = "${local.function_source_dir}.zip"
  source_code_hash = data.archive_file.function_zip.output_base64sha256

  role = aws_iam_role.iam_for_lambda.arn

}

data "archive_file" "function_zip" {
  source_dir  = local.function_source_dir
  type        = "zip"
  output_path = "${local.function_source_dir}.zip"
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "iam_for_lambda" {
  name               = "Lambda_Role_getelement"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

