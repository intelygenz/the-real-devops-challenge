# Solutions to DevOps challenge


## Challenge 1. The API returns a list instead of an object

* When the endpoint `/api/v1/restaurant/<id>` is hit, it calls the `find_restaurants` method in the [mongoflask](https://github.com/husker-du/the-real-devops-challenge/blob/master/src/mongoflask.py) module, which returns a list of objects either a restaurant identifier is provided or not.

* Given a restaurant identifier `id`, the service should find only one restaurant in the mongo database and return a single object containing the restaurant data.

* If no identifier is provided, a list of all the restaurants stored in the database must be returned.

* The new code for the `/api/v1/restaurant/<id>` endpoint is as follows:
```python
    @app.route("/api/v1/restaurant/<id>")
    def restaurant(id):
        restaurants = find_restaurants(mongo, id)
        return jsonify(restaurants[0]) if restaurants else make_response("Restaurant not found", 204)
```

* If any restaurant data has been populated in the list returned by the `find_restaurants` method for the given `id`, the first element of the list is returned, otherwise, we get an HTTP response with code **204**.


* In addition, in the `find_restaurants` method of the mongoflask module there's a typo error in the `id` variable. Instead of `ObjectId(id)`, it should be `ObjectId(_id)`.

```python
    def find_restaurants(mongo, _id=None):
        query = {}
        if _id:
            query["_id"] = ObjectId(_id)
        return list(mongo.db.restaurant.find(query))
```

<p>&nbsp;</p>

## Challenge 2. Test the application in any cicd system

* I'm going to use **Jenkins** as the CI/CD system to run the tests automatically when any change in the code is committed to the master branch. Jenkins is running in a docker and it delegates the build of the jobs of the pipelines to agent nodes. I've used Terraform to create AWS instances that can be used as worker nodes for the Jenkins master. Running `terraform init` and `terraform apply` in the [terraform](https://github.com/husker-du/the-real-devops-challenge/blob/master/jenkins-ci/terraform) directory should generate a specified number of jenkins worker nodes. To destroy the instances, run the command `terraform destroy`.

* A **tox** docker container is used in order to run the tests, therefore no tox installation is needed.
```
  $ docker run -it -v $(pwd):/tmp/app -w /tmp/app --rm painless/tox /bin/bash tox
```

* To check the **code coverage** of the tests, the `pytest-cov` package is used and html reports are generated in a `htmlcov` directory. For this reason, the `pytest-cov` is included in the [requirements_dev.txt](https://github.com/husker-du/the-real-devops-challenge/blob/master/requirements_dev.txt) file:
```
  -r requirements.txt
  pytest-cov
  mock
```

* The coverage is run by setting the command `pytest --cov-report html --cov src.mongoflask tests/` in the [tox.ini](https://github.com/husker-du/the-real-devops-challenge/blob/master/tox.ini) file:
```
  [tox]
  envlist = py27,py34,py35,py36
  skipsdist=True

  [testenv]
  deps = -rrequirements_dev.txt
  commands = pytest --cov-report html --cov src.mongoflask tests/
  setenv = MONGO_URI = mongodb://test
```


* This is the [Jenkinsfile](https://github.com/husker-du/the-real-devops-challenge/blob/master/Jenkinsfile) that automates the tests of the application whenever a changed is committed to the master branch:

```groovy
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
          publishHTML (target: [
              reportDir: 'htmlcov', 
              reportFiles: 'index.html',
              reportName: "Coverage Report"
          ])
        }
      }
    }
    post {
      always {
        echo 'One way or another, I have finished'
        deleteDir() /* clean up our workspace */
      }
      success {
        echo 'Pipeline success'
      }
      failure {
        echo 'Pipeline failure'
      }
    }
  }
```
The HTML publisher plugin is used to publish the coverage reports to the Jenkins job.
