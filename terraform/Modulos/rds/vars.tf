variable "db_password" {
  description = "The password for the database user"
  type        = string
}

variable "subnet_group_name" {
  description = "The name of the DB subnet group"
  type        = string
}

variable "rds_sg_id" {
  description = "The ID of the security group"
  type        = string
}