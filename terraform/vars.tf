variable "region" {
    default = "europe-southwest1"
}
variable "project_id" {
    default = "flowing-scholar-463011-d0"
}
variable "network" {
    default = "vpc-gcp"
}
variable "bgp_asn" {
  default = 65002
}

variable "db_password" {
  description = "The password for the database user"
  type        = string
}
