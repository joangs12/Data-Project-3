locals {
  function_name               = "getelement"
  function_handler            = "main.handler"
  function_runtime            = "python3.12"
  function_timeout_in_seconds = 5

  function_source_dir = "${path.module}/src/${local.function_name}"
}

resource "aws_lambda_function" "getelement_function" {
  function_name = local.function_name
  timeout       = 5 # seconds
  image_uri = "859043920908.dkr.ecr.eu-central-1.amazonaws.com/repo-dp3@sha256:610b37ffb7ca57c3043c61edff079bd2f8d2b960c86cb690686aa2bcedb9bb22"
  package_type  = "Image"

  role = aws_iam_role.iam_for_lambda.arn
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

resource "aws_iam_role_policy_attachment" "lambda_vpc_access" {
  role       = aws_iam_role.iam_for_lambda.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}




##------------------------------------------------------------------------------------------------------
# resource "aws_ecr_repository" "repo_dp3" {
#   name = "repo-dp3"
#   force_delete = true
# }


# resource "aws_iam_role" "ecr_push_role" {
#   name = "ecr-push-role"
#   assume_role_policy = jsonencode({
#     Version = "2012-10-17",
#     Statement = [
#       {
#         Action = "sts:AssumeRole",
#         Effect = "Allow",
#         Principal = {
#           Service = "ecs-tasks.amazonaws.com"
#         }
#       }
#     ]
#   })
# }

# resource "aws_iam_role_policy" "ecr_push_policy" {
#   name = "ecr-push-policy"
#   role = aws_iam_role.ecr_push_role.id
#   policy = jsonencode({
#     Version = "2012-10-17",
#     Statement = [
#       {
#         Action = [
#           "ecr:GetDownloadUrlForLayer",
#           "ecr:BatchGetImage",
#           "ecr:BatchCheckLayerAvailability",
#           "ecr:PutImage",
#           "ecr:InitiateLayerUpload",
#           "ecr:UploadLayerPart",
#           "ecr:CompleteLayerUpload"
#         ],
#         Effect = "Allow",
#         Resource = aws_ecr_repository.repo_dp3.arn
#       }
#     ]
#   })
# }

# resource "null_resource" "docker_build_and_push" {
#   triggers = {
#     always_run = "${timestamp()}"
#   }    
#   provisioner "local-exec" {
#     command = <<EOT
#       aws ecr get-login-password --region eu-central-1 | docker login --username AWS --password-stdin ${aws_ecr_repository.repo_dp3.repository_url} && docker buildx build --platform linux/amd64 -t repo-dp3 D:\EDEM\CLOUD\Data-Project-3\terraform\Modulos\lambda_function\src\getelement && docker tag repo-dp3:latest ${aws_ecr_repository.repo_dp3.repository_url}:latest && docker push ${aws_ecr_repository.repo_dp3.repository_url}:latest
#     EOT
#   }
#   depends_on = [aws_ecr_repository.repo_dp3]
# }

# data "aws_ecr_image" "my_image" {
#   repository_name = aws_ecr_repository.repo_dp3.name
#   image_tag       = "latest"
#   depends_on      = [null_resource.docker_build_and_push]
# }
