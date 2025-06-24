resource "aws_ecr_repository" "repo_dp3" {
  name = "repo-dp3"
  force_delete = true
}


resource "aws_iam_role" "ecr_push_role" {
  name = "ecr-push-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy" "ecr_push_policy" {
  name = "ecr-push-policy"
  role = aws_iam_role.ecr_push_role.id
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = [
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage",
          "ecr:BatchCheckLayerAvailability",
          "ecr:PutImage",
          "ecr:InitiateLayerUpload",
          "ecr:UploadLayerPart",
          "ecr:CompleteLayerUpload"
        ],
        Effect = "Allow",
        Resource = aws_ecr_repository.repo_dp3.arn
      }
    ]
  })
}

resource "null_resource" "docker_build_and_push" {
  triggers = {
    always_run = "${timestamp()}"
  }    
  provisioner "local-exec" {
    command = <<EOT
      aws ecr get-login-password --region eu-central-1 | docker login --username AWS --password-stdin ${aws_ecr_repository.repo_dp3.repository_url} && docker buildx build --platform linux/amd64 -t repo-dp3 D:\EDEM\CLOUD\Data-Project-3\terraform\Modulos\lambda_function\src\getelement && docker tag repo-dp3:latest ${aws_ecr_repository.repo_dp3.repository_url}:latest && docker push ${aws_ecr_repository.repo_dp3.repository_url}:latest
    EOT
  }
  depends_on = [aws_ecr_repository.repo_dp3]
}

data "aws_ecr_image" "my_image" {
  repository_name = aws_ecr_repository.repo_dp3.name
  image_tag       = "latest"
  depends_on      = [null_resource.docker_build_and_push]
}

provider "aws" {
  region = "eu-central-1"
  
}