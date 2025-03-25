pipeline {
    agent any

    environment {
        AWS_CREDENTIALS = credentials('AWS-DOCKER-CREDENTIALS') // Stores both Access & Secret Key
        DOCKER_ACCESS_KEY = credentials('DOCKER_ACCESS_KEY') // Stores Docker Personal Access Token
    }

    stages {
        stage('Clone Repository') {
            steps {
                git branch: 'main', url: 'https://github.com/SefaliSabnam/DOCKER-WITH-TERRAFORM.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t your-dockerhub-username/app .'
            }
        }

        stage('Push Docker Image') {
            steps {
                sh 'echo $DOCKER_ACCESS_KEY | docker login -u your-dockerhub-username --password-stdin'
                sh 'docker push your-dockerhub-username/app'
            }
        }

        stage('Deploy to AWS') {
            when {
                branch 'main'
            }
            steps {
                withCredentials([aws(credentialsId: 'AWS_CREDENTIALS')]) {
                    sh 'terraform init'
                    sh 'terraform apply -auto-approve'
                }
            }
        }
    }
}
