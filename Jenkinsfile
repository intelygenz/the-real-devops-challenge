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
                sh './test.sh'
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
