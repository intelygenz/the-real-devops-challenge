pipeline {
    agent any 
    stages {
        stage('Checkout') {
            steps {
                checkout scm 
            }
        }
        stage('Build') { 
            steps {
                sh './build_and_push.sh'
            }
        }
        stage('Test') { 
            steps {
                sh 'docker run -v $(pwd):/tmp/app -w /tmp/app --rm painless/tox /bin/bash tox'
            }
        }
        stage('Deploy') { 
            steps {
                sh "echo kubectl --context 'dev' create -f ./k8s "
            }
        }
    }
}
