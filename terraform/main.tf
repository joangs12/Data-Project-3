
module "BigQuery" {
  source = "./Modulos/BigQuery"
  
}

module "Datastream" {
  source = "./Modulos/Datastream"
  db_password = module.rds_instance.db_password
  db_username = module.rds_instance.db_user
  db_name     = module.rds_instance.db_name
  datastream_username = var.datastream_username
  datastream_password = var.datastream_password 
}

module "getelement" {
  source           = "./AWS/Modulos/lambda_function"
  lambda_sg_id     = module.vpc_sg.lambda_sg_id
  private_subnet_a = module.vpc_sg.private_subnet_a
  private_subnet_b = module.vpc_sg.private_subnet_b
  db_host          = module.rds_instance.db_host
  db_port          = module.rds_instance.db_port
  db_name          = module.rds_instance.db_name
  db_user          = module.rds_instance.db_user
  db_password      = var.db_password
  image_uri        = module.ecr_getelement.image_uri
  function_name    = "getelement"
  arn_lambda_role  = module.iam_roles.arn_lambda_role
}

module "ecr_getelement" {
  source = "./AWS/Modulos/ECR"
  path_docker = "D:/EDEM/CLOUD/Data-Project-3/terraform/AWS/Modulos/lambda_function/src/getelement"
  name_repo = module.repo_ecr.name_repo
  url_repo  = module.repo_ecr.url_repo
}

module "setup" {
  source           = "./AWS/Modulos/lambda_function"
  lambda_sg_id     = module.vpc_sg.lambda_sg_id
  private_subnet_a = module.vpc_sg.private_subnet_a
  private_subnet_b = module.vpc_sg.private_subnet_b
  db_host          = module.rds_instance.db_host
  db_port          = module.rds_instance.db_port
  db_name          = module.rds_instance.db_name
  db_user          = module.rds_instance.db_user
  db_password      = var.db_password
  image_uri        = module.ecr_setup.image_uri
  function_name    = "setup"
  arn_lambda_role  = module.iam_roles.arn_lambda_role
}

module "ecr_setup" {
  source = "./AWS/Modulos/ECR"
  path_docker = "D:/EDEM/CLOUD/Data-Project-3/terraform/AWS/Modulos/lambda_function/src/setup"
  name_repo = module.repo_ecr.name_repo
  url_repo  = module.repo_ecr.url_repo
}

module "addproduct" {
  source           = "./AWS/Modulos/lambda_function"
  lambda_sg_id     = module.vpc_sg.lambda_sg_id
  private_subnet_a = module.vpc_sg.private_subnet_a
  private_subnet_b = module.vpc_sg.private_subnet_b
  db_host          = module.rds_instance.db_host
  db_port          = module.rds_instance.db_port
  db_name          = module.rds_instance.db_name
  db_user          = module.rds_instance.db_user
  db_password      = var.db_password
  image_uri        = module.ecr_addproduct.image_uri
  function_name    = "addproduct"
  arn_lambda_role  = module.iam_roles.arn_lambda_role
}

module "ecr_addproduct" {
  source = "./AWS/Modulos/ECR"
  path_docker = "D:/EDEM/CLOUD/Data-Project-3/terraform/AWS/Modulos/lambda_function/src/addproduct"
  name_repo = module.repo_ecr.name_repo
  url_repo  = module.repo_ecr.url_repo
}

module "buy_product" {
  source           = "./AWS/Modulos/lambda_function"
  lambda_sg_id     = module.vpc_sg.lambda_sg_id
  private_subnet_a = module.vpc_sg.private_subnet_a
  private_subnet_b = module.vpc_sg.private_subnet_b
  db_host          = module.rds_instance.db_host
  db_port          = module.rds_instance.db_port
  db_name          = module.rds_instance.db_name
  db_user          = module.rds_instance.db_user
  db_password      = var.db_password
  image_uri        = module.ecr_buy_product.image_uri
  function_name    = "buy_product"
  arn_lambda_role  = module.iam_roles.arn_lambda_role
}

module "ecr_buy_product" {
  source = "./AWS/Modulos/ECR"
  path_docker = "D:/EDEM/CLOUD/Data-Project-3/terraform/AWS/Modulos/lambda_function/src/buy_product"
  name_repo = module.repo_ecr.name_repo
  url_repo = module.repo_ecr.url_repo
}

module "rds_instance" {
  source            = "./AWS/Modulos/rds"
  rds_sg_id         = module.vpc_sg.rds_sg_id
  db_password       = var.db_password
  subnet_group_name = module.vpc_sg.rds_subnet_group_name
}

module "vpc_sg" {
  source = "./AWS/Modulos/VPC+SG"

}

module "iam_roles" {
  source = "./AWS/iam_roles"
}

module "cloudRun" {
  source = "./GCP/Modulos/CloudRun"
}

module "repo_ecr" {
  source = "./AWS/Modulos/repo-ecr"

}