resource "aws_instance" "app_server" {
  ami                    = "ami-08b5b3a93ed654d19"
  instance_type          = var.instance_type
  iam_instance_profile   = var.iam_role
  key_name               = var.key_name
  security_groups        = [aws_security_group.app_sg.name]
  user_data              = file("${path.module}/user_data.sh")
}
