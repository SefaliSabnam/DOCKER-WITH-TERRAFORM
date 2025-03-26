pipeline {
    agent any

    environment {
        DOCKER_HUB_USER = 'sefali26'
        IMAGE_NAME = 'sefali26/my-website'
        IMAGE_TAG = 'latest'
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

        stage('Verify Dockerfile') {
            steps {
                script {
                    sh "ls -l"  // Check if Dockerfile exists
                }
            }
        }

        stage('Build Docker Image') {
            when {
                branch 'main'  // Build only after merge
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

        stage('Terraform Init & Apply') {
            when {
                branch 'main'
            }
            steps {
                script {
                    withCredentials([
                        string(credentialsId: 'AWS_ACCESS_KEY_ID_1', variable: 'AWS_ACCESS_KEY'),
                        string(credentialsId: 'AWS_SECRET_ACCESS_KEY_1', variable: 'AWS_SECRET_KEY')
                    ]) {
                        sh """
                        export AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY
                        export AWS_SECRET_ACCESS_KEY=$AWS_SECRET_KEY
                        terraform init
                        terraform apply -auto-approve
                        """
                    }
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
