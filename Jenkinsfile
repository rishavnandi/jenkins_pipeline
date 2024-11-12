pipeline {
    agent any
    
    environment {
        DOCKER_CREDENTIALS = credentials('docker-hub-credentials')
        DOCKER_IMAGE = "your-dockerhub-username/your-app-name"
        DOCKER_TAG = "${env.GIT_COMMIT.take(7)}"
        AWS_CREDENTIALS = credentials('aws-credentials')
    }
    
    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }
        
        stage('Build Docker Image') {
            steps {
                sh """
                    docker build -t ${DOCKER_IMAGE}:${DOCKER_TAG} .
                    docker tag ${DOCKER_IMAGE}:${DOCKER_TAG} ${DOCKER_IMAGE}:latest
                """
            }
        }
        
        stage('Push Docker Image') {
            steps {
                sh """
                    echo ${DOCKER_CREDENTIALS_PSW} | docker login -u ${DOCKER_CREDENTIALS_USR} --password-stdin
                    docker push ${DOCKER_IMAGE}:${DOCKER_TAG}
                    docker push ${DOCKER_IMAGE}:latest
                """
            }
        }
        
        stage('Update Application Version') {
            steps {
                sh """
                    sed -i 's|docker_image:.*|docker_image: ${DOCKER_IMAGE}:${DOCKER_TAG}|' main-server/ansible/vars.yml
                """
            }
        }
        
        stage('Deploy Infrastructure') {
            environment {
                AWS_ACCESS_KEY_ID = "${AWS_CREDENTIALS_USR}"
                AWS_SECRET_ACCESS_KEY = "${AWS_CREDENTIALS_PSW}"
            }
            steps {
                dir('main-server/terraform') {
                    sh """
                        terraform init
                        terraform apply -auto-approve
                    """
                }
            }
        }
        
        stage('Deploy Application') {
            steps {
                dir('main-server/ansible') {
                    sh """
                        ansible-playbook -i inventory.ini playbook.yml
                    """
                }
            }
        }
    }
    
    post {
        always {
            sh 'docker logout'
        }
    }
} 