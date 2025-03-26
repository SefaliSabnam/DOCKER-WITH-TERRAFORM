pipeline {
    agent any

    environment {
        AWS_CREDENTIALS = credentials('AWS-DOCKER-CREDENTIALS') // AWS Access & Secret Key
    }

    stages {
        stage('Clone Repository') {
            steps {
                git branch: 'main', url: 'https://github.com/SefaliSabnam/DOCKER-WITH-TERRAFORM.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    sh '''
                    echo "Building Docker Image..."
                    docker build -t sefali26/app:latest .
                    '''
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                withCredentials([string(credentialsId: 'DOCKER_HUB_TOKEN', variable: 'DOCKER_ACCESS_KEY')]) {
                    script {
                        sh '''
                        echo "Logging in to Docker Hub..."
                        echo $DOCKER_ACCESS_KEY | docker login -u sefali26 --password-stdin
                        
                        echo "Pushing Docker Image..."
                        docker push sefali26/app:latest
                        '''
                    }
                }
            }
        }

        stage('Deploy to AWS') {
            when {
                branch 'main'
            }
            steps {
                withAWS(credentials: 'AWS-DOCKER-CREDENTIALS', region: 'ap-south-1') {
                    script {
                        sh '''
                        echo "Initializing Terraform..."
                        terraform init -backend=true

                        echo "Applying Terraform configuration..."
                        terraform apply -auto-approve
                        '''
                    }
                }
            }
        }
    }

    post {
        failure {
            script {
                echo "Build failed! Check the logs for errors."
            }
        }
        success {
            script {
                echo "Build and deployment successful!"
            }
        }
    }
}
