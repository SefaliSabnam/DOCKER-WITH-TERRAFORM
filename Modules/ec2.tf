resource "aws_instance" "docker_host" {
  ami             = "ami-05c179eced2eb9b5b"
  instance_type   = "t2.micro"
  key_name        = "my-key"
  subnet_id       = aws_subnet.public_subnet.id  
  vpc_security_group_ids = [aws_security_group.allow_http_ssh.id]

  user_data = <<EOF
  #!/bin/bash
  sudo yum update -y
  sudo yum install -y docker git
  sudo systemctl start docker
  sudo usermod -aG docker ec2-user
  EOF
}
