#!/bin/groovy

pipeline{
    agent any
    stages{
        stage("Build Container"){
            steps{
                echo "======== Executing Build Container ========"
                dir('the-real-devops-challenge/'){
                    sh('make container')
                }
            }
            post{
                always{
                    echo "======== Always ========"
                }
                success{
                    echo "======== Build Container Executed Successfully ========"
                }
                failure{
                    echo "======== Build Container Execution Failed ========"
                }
            }
        }
        stage("Test"){
            steps{
                echo "======== Executing Test Container ========"
                dir('the-real-devops-challenge/'){
                    sh('make test')
                }
            }
            post{
                always{
                    echo "======== Always ========"
                }
                success{
                    echo "======== Test Container Executed Successfully ========"
                }
                failure{
                    echo "======== Test Container Execution Failed ========"
                }
            }
        }
        stage("Build Compose"){
            steps{
                echo "======== Executing Build Compose ========"
                dir('the-real-devops-challenge/'){
                    sh('make cluster')
                }
            }
            post{
                always{
                    echo "======== Always ========"
                }
                success{
                    echo "======== Build Compose Executed Successfully ========"
                }
                failure{
                    echo "======== Build Compose Execution Failed ========"
                }
            }
        }
    }
    post{
        always{
            echo "========always========"
        }
        success{
            echo "========pipeline executed successfully ========"
        }
        failure{
            echo "========pipeline execution failed========"
        }
    }
}