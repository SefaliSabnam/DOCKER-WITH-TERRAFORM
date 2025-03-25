resource "aws_iam_role" "ec2_role" {
  name               = var.role_name
  assume_role_policy = file("${path.module}/policy.json")
}
