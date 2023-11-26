pipeline {
    agent any
    
    environment {
        DOCKER_CREDENTIALS = 'af3bf4df-c402-4c86-8367-03bb2c9e5884'
    }

    tools {
        maven 'Maven 3.9.5'
        jdk 'Java 11'
    }
    
    stages {
        
        stage('Docker Login') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: "${DOCKER_CREDENTIALS}", passwordVariable: 'DOCKER_PASSWORD', usernameVariable: 'DOCKER_USERNAME')]) {
                        sh "docker login -u ${DOCKER_USERNAME} -p ${DOCKER_PASSWORD}"
                    }
                }
            }
        }

        stage('Build WAR') {
            steps {
                dir('HW3') {
                    script {
                        // Set JAVA_HOME explicitly before the Maven command
                        env.JAVA_HOME = '/usr/lib/jvm/java-17-openjdk-amd64'
                    }
                    sh '''
                        echo $JAVA_HOME
                        mvn clean install
                    '''
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                dir('HW3') {
                    script {
                        def tagName = "v" + env.BUILD_NUMBER // using Jenkins build number as an example
                        def dockerImageName = "akshathphillipspersonal/swe645-hw3:${tagName}"
                        def dockerImage = docker.build(dockerImageName)
                        env.DOCKER_TAG_NAME = tagName
                    }
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    sh "docker push akshathphillipspersonal/swe645-hw3:${env.DOCKER_TAG_NAME}"
                }
            }
        }
        
        stage('Deploy to Kubernetes') {
            steps {
                script {
                    def kubeconfigPath = "/var/lib/jenkins/kubeconfig"
                    // Use the DOCKER_TAG_NAME for deployment
                    sh "sed -i 's|akshathphillipspersonal/swe645-hw3:.*|akshathphillipspersonal/swe645-hw3:${env.DOCKER_TAG_NAME}|' HW3/deployment.yml"
                    sh "kubectl --kubeconfig ${kubeconfigPath} apply -f HW3/deployment.yml"
                }
            }
        }
    }
}
