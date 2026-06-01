module "vpc" {
  source = "./module/vpc"

  project_name       = var.project_name
  vpc_cidr           = var.vpc_cidr
  public_subnet_cidr = var.public_subnet_cidr
  availability_zone  = var.availability_zone
}

module "ec2" {
  source = "./module/ec2"

  project_name  = var.project_name
  subnet_id     = module.vpc.public_subnet_id
  vpc_id        = module.vpc.vpc_id
  instance_type = var.instance_type
}