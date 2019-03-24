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
                sh './build.sh'
            }
        }
        
        stage('Test') { 
            steps {
                sh 'docker run -it -v $(pwd):/tmp/app -w /tmp/app --rm painless/tox /bin/bash tox'
            }
        }

        stage('Push') {
            steps {
                sh './push.sh'
            }
        }

        stage('Deploy') { 
            steps {
                sh 'echo TODO'
            }
        }
    }
} 
