provider "aws" {
  region = "ap-south-1"
}

module "s3" {
  source      = "./modules/s3"
  bucket_name = "my-app-storage-bucket-123"
}

module "iam" {
  source      = "./modules/iam"
  role_name   = "ec2_s3_access_role"
}

module "ec2" {
  source        = "./modules/ec2"
  instance_type = "t2.micro"
  iam_role      = module.iam.role_name
  key_name      = "your-key"
}
