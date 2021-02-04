pipeline {
  agent any
  options { 
    ansiColor('xterm')
    buildDiscarder(logRotator(numToKeepStr: '5'))
    timeout(time: 5, unit: 'MINUTES')
  }
  stages {
    stage ("Tests") {
      steps {
        sh 'docker run -i -v $(pwd):/tmp/app -w /tmp/app --rm painless/tox /bin/bash tox'
        sh 'docker run -i -v $(pwd):/tmp/app -w /tmp/app --rm painless/tox /bin/bash -c \
            "chown -R $(id -u):$(id -g) .tox .coverage htmlcov tests src"'
      }
      post {
        success {
          // Publish coverage report
          publishHTML (target: [
              reportDir: 'htmlcov', 
              reportFiles: 'index.html',
              reportName: "Coverage Report"
          ])
        }
      }
    }
  }
  post {
    always {
      echo 'Clean up our workspace directory'
      deleteDir()
    }
    success {
      echo 'Pipeline success'
    }
    failure {
      echo 'Pipeline failure'
    }
  }
}
