variable "project_name" {
  type = string
}

variable "private_subnets" {
  type = list(string)
}
variable "bastion_security_group_id" {
  type = string
}

