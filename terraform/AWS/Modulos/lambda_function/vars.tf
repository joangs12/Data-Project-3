variable "lambda_sg_id" {
  description = "The ID of the Lambda security group"
  type        = string
}

variable "private_subnet_a" {
  description = "The ID of the private subnet A"
  type        = string
}

variable "private_subnet_b" {
  description = "The ID of the private subnet B"
  type        = string
}

variable "db_host" {
  description = "The database host"
  type        = string
  
}

variable "db_port" {
  description = "The database port"
  type        = number
}

variable "db_name" {
  description = "The database name"
  type        = string
}

variable "db_user" {
  description = "The database user"
  type        = string
}

variable "db_password" {
  description = "The database password"
  type        = string
}

variable "image_uri" {
  description = "The URI of the Docker image in ECR"
  type        = string
  
}

variable "function_name" {
  description = "The name of the Lambda function"
  type        = string
  
}

variable "arn_lambda_role" {
  description = "The ARN of the Lambda execution role"
  type        = string
}