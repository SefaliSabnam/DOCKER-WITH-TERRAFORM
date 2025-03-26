pipeline {
    agent any

    environment {
        DOCKER_HUB_USER = 'sefali26'
        IMAGE_NAME = 'sefali26/my-website'
        IMAGE_TAG = 'latest'
        AWS_ACCESS_KEY_ID = credentials('AWS-DOCKER-CREDENTIALS')
    }

    stages {
        stage('Checkout Code') {
            steps {
                git 'https://github.com/SefaliSabnam/DOCKER-WITH-TERRAFORM.git' // Replace with your repo URL
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    sh "docker build -t ${IMAGE_NAME}:${IMAGE_TAG} ."
                }
            }
        }

        stage('Login to Docker Hub') {
            steps {
                script {
                    withCredentials([string(credentialsId: 'DOCKER_HUB_TOKEN', variable: 'DOCKER_TOKEN')]) {
                        sh "echo $DOCKER_TOKEN | docker login -u ${DOCKER_HUB_USER} --password-stdin"
                    }
                }
            }
        }

        stage('Push to Docker Hub') {
            steps {
                script {
                    sh "docker push ${IMAGE_NAME}:${IMAGE_TAG}"
                }
            }
        }

        stage('Terraform Init & Apply') {
            when {
                branch 'main'  // Runs only if merged into 'main'
            }
            steps {
                script {
                    sh """
                    terraform init
                    terraform apply -auto-approve
                    """
                }
            }
        }

        stage('Cleanup') {
            steps {
                sh "docker rmi ${IMAGE_NAME}:${IMAGE_TAG}"
            }
        }
    }
}
