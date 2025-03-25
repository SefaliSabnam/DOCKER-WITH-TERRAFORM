pipeline {
    agent any

    environment {
        AWS_CREDENTIALS = credentials('AWS-DOCKER-CREDENTIALS') // Stores AWS Access & Secret Key
    }

    stages {
        stage('Clone Repository') {
            steps {
                git branch: 'main', url: 'https://github.com/SefaliSabnam/DOCKER-WITH-TERRAFORM.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t sefali26/app:latest .'
            }
        }

        stage('Push Docker Image') {
            steps {
                withCredentials([string(credentialsId: 'DOCKER_HUB_TOKEN', variable: 'DOCKER_ACCESS_KEY')]) {
                    sh '''
                    echo $DOCKER_ACCESS_KEY | docker login -u sefali26 --password-stdin
                    docker push sefali26/app:latest
                    '''
                }
            }
        }

        stage('Deploy to AWS') {
            when {
                branch 'main'
            }
            steps {
                withAWS(credentials: 'AWS-DOCKER-CREDENTIALS', region: 'ap-south-1') {
                    sh '''
                    terraform init
                    terraform apply -auto-approve
                    '''
                }
            }
        }
    }
}
