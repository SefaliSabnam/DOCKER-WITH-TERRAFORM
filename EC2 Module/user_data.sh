#!/bin/bash
sudo yum update -y
sudo yum install docker -y
sudo systemctl start docker
sudo systemctl enable docker
usermod -aG docker ec2-user
docker run -d -p 80:3000 your-dockerhub-username/app
