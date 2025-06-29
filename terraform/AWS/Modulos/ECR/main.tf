


resource "null_resource" "docker_build_and_push" {
  triggers = {
    always_run = "${timestamp()}"
  }    
  provisioner "local-exec" {
    command = <<EOT
      aws ecr get-login-password --region eu-central-1 | docker login --username AWS --password-stdin ${var.url_repo} && docker build -t repo-dp3 ${var.path_docker} && docker tag repo-dp3:latest ${var.url_repo}:latest && docker push ${var.url_repo}:latest
    EOT
  }

}

data "aws_ecr_image" "my_image" {
  repository_name = var.name_repo
  image_tag       = "latest"
  depends_on      = [null_resource.docker_build_and_push]
}

provider "aws" {
  region = "eu-central-1"
  
}