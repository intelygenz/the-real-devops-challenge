
pipeline {
    agent any

    stages {
        stage('Checkout'){
            steps {
			    checkout scm
			 }
		}
        stage('Prepare') {
            steps {
                sh "pip install tox"
             }
        }
        stage('Test') {
            steps {
                sh "tox"
             }
        }
        stage('Build image'){
            steps {
                sh "docker build -t challengeapp ."
            }
        }
    }
}