pipeline{
    agent{
        label "slave1"
    }
    stages{

        stage("Checkout"){
            steps{
                echo "========Starting checkout========"
            }
            post{
                always{
                    echo "========Checkout finished========"
                }
                success{
                    echo "========Checkout executed successfully========"
                }
                failure{
                    echo "========Checkout execution failed========"
                }
            }
        }

        stage("Build"){
            steps{
                echo "========Executing Build========"
            }
            post{
                always{
                    echo "========Build finished========"
                }
                success{
                    echo "========Build executed successfully========"
                }
                failure{
                    echo "========Build execution failed========"
                }
            }
        }

        stage("Test"){
            steps{
                echo "========Starting test========"
            }
            post{
                always{
                    echo "========Test finished========"
                }
                success{
                    echo "========Test executed successfully========"
                }
                failure{
                    echo "========Test execution failed========"
                }
            }
        }

        stage("Deploy"){
            steps{
                echo "========Starting deploy========"
            }
            post{
                always{
                    echo "========Deploy finished========"
                }
                success{
                    echo "========Deploy executed successfully========"
                }
                failure{
                    echo "========Deploy execution failed========"
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