module "lambdas_functions" {
  source           = "./Modulos/lambda_function"
  lambda_sg_id     = module.vpc_sg.lambda_sg_id
  private_subnet_a = module.vpc_sg.private_subnet_a
  private_subnet_b = module.vpc_sg.private_subnet_b
  db_host          = module.rds_instance.db_host
  db_port          = module.rds_instance.db_port
  db_name          = module.rds_instance.db_name
  db_user          = module.rds_instance.db_user
  db_password      = var.db_password
}

module "rds_instance" {
  source            = "./Modulos/rds"
  rds_sg_id         = module.vpc_sg.rds_sg_id
  db_password       = var.db_password
  subnet_group_name = module.vpc_sg.rds_subnet_group_name
}

module "vpc_sg" {
  source = "./Modulos/VPC+SG"

}