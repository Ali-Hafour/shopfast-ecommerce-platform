variable "aws_region"      { default = "eu-west-1" }
variable "project_name"    { default = "ecommerce" }
variable "instance_type"   { default = "t3.medium" }
variable "key_name"        { description = "Existing EC2 key pair name" type = string }
variable "db_username"     { default = "ecommerce" }
variable "db_password"     { description = "RDS master password" type = string sensitive = true }
variable "vpc_cidr"        { default = "10.0.0.0/16" }
