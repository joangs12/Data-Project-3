# module "lambdas_functions" {
#   source          = "./Modulos/lambda_function"
# }

module "rds_instance" {
  source = "./Modulos/rds"

  db_password = var.db_password
}