output "image_uri" {
  value = "${var.url_repo}}@${data.aws_ecr_image.my_image.image_digest}"
}