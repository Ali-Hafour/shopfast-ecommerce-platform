module "vpc" {
  source = "./modules/vpc"

  project_name = var.project_name
}
module "ecr" {
  source = "./modules/ecr"

  project_name = var.project_name
}
module "eks" {
  source = "./modules/eks"

  project_name    = var.project_name
  private_subnets = module.vpc.private_subnets
}
module "ec2" {
  source = "./modules/ec2"

  project_name     = var.project_name
  vpc_id           = module.vpc.vpc_id
  public_subnet_id = module.vpc.public_subnets[0]
  key_name         = "DevOps"
}

