provider "aws" {
  region = "ap-south-1"
}

module "vpc" {
  source = "./modules/vpc"
}

module "ec2" {
  source = "./modules/ec2"
  public_subnet_id = module.vpc.public_subnet_id
}

module "ecr" {
  source = "./modules/ecr"
}
