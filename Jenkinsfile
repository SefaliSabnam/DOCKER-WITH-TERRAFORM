pipeline {
    agent any

    environment {
        DOCKER_HUB_USER = 'sefali26'
        IMAGE_NAME = 'sefali26/my-website'
        IMAGE_TAG = 'latest'
        AWS_ACCESS_KEY_ID = credentials('AWS-DOCKER-CREDENTIALS') // AWS Credentials
    }

    stages {
        stage('Checkout Code') {
            steps {
                script {
                    checkout([$class: 'GitSCM', 
                        branches: [[name: '*/${BRANCH_NAME}']], 
                        extensions: [[$class: 'CleanBeforeCheckout'], [$class: 'WipeWorkspace']],
                        userRemoteConfigs: [[url: 'https://github.com/SefaliSabnam/DOCKER-WITH-TERRAFORM.git']]
                    ])
                }
            }
        }

        stage('Verify Files') {
            steps {
                script {
                    sh "ls -l"  // Check if index.html & Dockerfile exist
                }
            }
        }

        stage('Build Docker Image') {
            when {
                branch 'main'  // Only run after merge to main
            }
            steps {
                script {
                    sh "docker build -t ${IMAGE_NAME}:${IMAGE_TAG} ."
                }
            }
        }

        stage('Login to Docker Hub') {
            when {
                branch 'main'
            }
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: 'DOCKER_HUB_TOKEN', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                        sh "echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin"
                    }
                }
            }
        }

        stage('Push to Docker Hub') {
            when {
                branch 'main'
            }
            steps {
                script {
                    sh "docker push ${IMAGE_NAME}:${IMAGE_TAG}"
                }
            }
        }

        stage('Terraform Init') {
            steps {
                script {
                    sh "terraform init"
                }
            }
        }

        stage('Terraform Plan') {
            steps {
                script {
                    sh "terraform plan -out=tfplan"
                }
            }
        }

        stage('Terraform Apply') {
            when {
                branch 'main'  // Apply only after merge to main
            }
            steps {
                script {
                    sh "terraform apply -auto-approve tfplan"
                }
            }
        }

        stage('Cleanup') {
            when {
                branch 'main'
            }
            steps {
                sh "docker rmi ${IMAGE_NAME}:${IMAGE_TAG}"
            }
        }
    }
}
