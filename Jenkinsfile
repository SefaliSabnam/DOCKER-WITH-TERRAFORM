pipeline {
    agent any
    environment {
        AWS_REGION = "ap-south-1"
        AWS_ACCOUNT_ID = "DOCKER-ACCESS-KEY"
        ECR_REPO = "my-app-repo"
    }
    stages {
        stage('Clone Repository') {
            steps {
                git branch: 'main', url: 'https://github.com/SefaliSabnam/DOCKER-WITH-TERRAFORM.git'
            }
        }
        stage('Build Docker Image') {
            steps {
                sh 'docker build -t my-app .'
            }
        }
        stage('Login to AWS ECR') {
            steps {
                sh '''
                aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com
                '''
            }
        }
        stage('Tag and Push Image') {
            steps {
                sh '''
                docker tag my-app:latest $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$ECR_REPO:latest
                docker push $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$ECR_REPO:latest
                '''
            }
        }
        stage('Deploy to EC2') {
            steps {
                sh '''
                ssh -i my-key.pem ec2-user@EC2_PUBLIC_IP << EOF
                docker pull $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$ECR_REPO:latest
                docker run -d -p 80:3000 $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$ECR_REPO:latest
                EOF
                '''
            }
        }
    }
}
