pipeline {
  agent { docker { image 'jcstdio/intely_app' } }
  stages {
    stage('build') {
      steps {
        sh 'pip install -r requirements.txt'
      }
    }
    stage('test') {
      steps {
        sh 'tox'
      }   
    }
  }
}
