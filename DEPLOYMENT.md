# The Real DevOps Challenge Deployment

These deployments assume scripts and commands are being ran on a localhost with [Docker installed and running](https://docs.docker.com/engine/install/) and [Minikube](https://v1-18.docs.kubernetes.io/docs/tasks/tools/install-minikube/) and [Kubectl](https://v1-18.docs.kubernetes.io/docs/tasks/tools/install-kubectl/) installed and accessible in your `$PATH`.

Running Minikube on my local development laptop resulted in cgroups being wiped out, Docker going belly up, and requiring a reboot, so I ran my Minikube environment in an OpenStack compute instance and a fresh Ubuntu 20.04 image.

Since the involved MongoDB data is already committed to a public repository, Mongo deployments do not assume security best practices and use the image's default admin user. This is for development and testing only and is *NOT* for production use.

## Updates to Project Code

Some portions of this project required bug fixes or completion.

* app.py now returns successful 200s or a 204 if a restaurant _id is not found.
* src/mongoflask.py had an invalid call to `id` instead of `_id`.
* tests/test_restaurant.py did not actually test anything within app.py or src/mongoflask.py, but only mocked some data and returned an array of that data. I realized this only after spending way too much time wondering why tests were successful even if I intentinally broke src/mongoflask.py. With the Docker unittest deployment a Mongo instance is now included with the original test data (3 docs) and tests/test_restaurant.py imported, so test_restaurant.py now makes direct calls to src.mongoflask.find_restaurant to validate the program's integrity. All three tests now check for the correct returned len(data) and type(data).

The deployment is split up between between two Docker Compose deployments involving:

* Docker Python UnitTesting: ./tests/docker-compose.yaml to run Tox tests.
* TravisCI automation: .travis-ci.yml runs ./tests/docker-compose.yaml through Travis-CI for automated testing.
* Docker Deployment of app.py: ./docker-compose.yaml for full app deployment in Docker.

and a Minikube deployment with:

* minikube/: directory containing K8S deployment stacks (described further below in the Minikube section)
* intelykube.sh: A Bash script to orchestrate the Minikube deployment (described further below in the Minikube section).


## Docker Compose UnitTesting (and Travis-CI build process)

Testing app.py with tests/test_restaurant.yml can be done locally, but is ran within Travis-CI within a pull request. 

```
:$ docker-compose -f tests/docker-compose.yaml up
```

If running locally, hit `ctrl+c` to exit out and stop containers.

The test deployment can be cleaned up with:

```
:$ docker-compose -f tests/docker-compose.yaml down -v
```

Travis-CI runs docker-compose with `-d` to background the deployment and then monitors `docker logs -f intelygenz-test.tox` to tail the Tox's container logs. `docker logs -f` returns either `exit 0` or `exit 1` allowing Travis-CI to return a success or failure back to GitHub when finished.


## Docker Compose Deployment

Then run the deployment with the docker-compose.yaml in the repo's root directory using `-d` to background stdout:

```
# To deploy, run within ./the-real-devops-challenge/ directory:
:$ docker-compose up -d
Creating intelygenz.mdb                        ... done
Creating the-real-devops-challenge_app_build_1 ... done
Creating intelygenz.app                        ... done
Creating the-real-devops-challenge_mdb_data_1  ... done
```

> The .dockerignore file should ignore .tox/, but in the event that docker-compose errors on root file permissions,
> run either `sudo rm -rf ./.tox/` or `sudo chown -R ${USER}:${USER} ./.tox/` so that Docker doesn't complain.

You should now have an endpoint accessible at localhost:8080:

```
# Use curl to access the API endpoint, for example:
:$ curl http://127.0.0.1:8080/api/v1/restaurant/55f14312c7447c3da7051b2b
{"URL":"http://www.just-eat.co.uk/restaurants-007takeaway-s65/menu","_id":"55f14312c7447c3da7051b2b","address":"6 Drummond Street","address line 2":"Rotherham","name":"007 Takeaway","outcode":"S65","postcode":"1HY","rating":6,"type_of_food":"Pizza"}
```

The deployment can be decommissioned with:

```
:$ docker-compose down -v && docker image rm -f intelygenz
Stopping intelygenz.app ... done
Stopping intelygenz.mdb ... done
Removing the-real-devops-challenge_mdb_data_1  ... done
Removing intelygenz.app                        ... done
Removing intelygenz.mdb                        ... done
Removing the-real-devops-challenge_app_build_1 ... done
Removing network the-real-devops-challenge_default
Removing the-real-devops-challenge_mdb_data_1  ... done
Untagged: intelygenz:latest                                                                                                                                    Removing intelygenz.app                        ... done
Deleted: sha256:967400474f30d5a15865e06d8c41c7f3c5d3176e6789aa9d52bf1e10d45dac3d
```

## Minikube Deployment

A Bash script `intelykube.sh` orchestrates this Minikube deployment to do the following:

* start minikube
* exports `minikube docker-env` variables
* build the App's Docker image
* creates a ConfigMap with data/restaurant.json data
* applies the stack files in minikube/
* port-forwards 8080 to access the deployed API endpoint locally

The minikube/ directory contains several K8S stack files:

* namespace.yaml: defines the 'intelygenz' namespace
* mdb-configmap-init.yaml: configMap of mongo-data JSON data and mongo-init mongoimport script
* mdb-deployment.yaml: Deploys a Mongo pod containing imported data from the configMap
* mdb-service.yaml: runs Mongo service on port 27017
* app-deployment.yaml: deploys the built intelygenz.app:latest image
* app-service.yaml: runs app service on port 8080


Running `./intelykube.sh up` should run through all necessary steps and leave you with a forwarded port on localhost:8080 and the above curl command should work just the same:

```
:$ curl http://127.0.0.1:8080/api/v1/restaurant/55f14312c7447c3da7051b2b
{"URL":"http://www.just-eat.co.uk/restaurants-007takeaway-s65/menu","_id":"55f14312c7447c3da7051b2b","address":"6 Drummond Street","address line 2":"Rotherham","name":"007 Takeaway","outcode":"S65","postcode":"1HY","rating":6,"type_of_food":"Pizza"}

```

Subsequent runs of `./intelykube.sh up` reapplies the deployment and can be used to maintain idempotency or push changes.

The script can also be sourced in Bash to gain use of the functions, for example the port forward can be stopped and started:

```
:$ source ./intelykube.sh
:$ stop_app_port_forward
Stopping PID: 1514697
:$ Terminated
:$ start_app_port_forward
Waiting for pod to start...
Port forwarding intelygenz-app-c6dd7bd98-7xlpq | 8080:8080 on localhost in the background.
 |_ Logging to => /home/ubuntu/the-real-devops-challenge/port-forward.log
 Access the API with 'curl http://127.0.0.1:8080/api/v1/restaurant'
  |_ Port-Forward running as PID: 1514983
```

The deployment can be decommissioned with `intelygenz.sh down` which stops the port forward, deletes the app image, and decommissions the 'intelygenz' namespace.
