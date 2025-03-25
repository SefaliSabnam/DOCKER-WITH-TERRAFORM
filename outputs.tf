output "ec2_public_ip" {
  value = module.ec2.ec2_public_ip
}

output "ecr_repository_url" {
  value = module.ecr.ecr_repo_url
}
