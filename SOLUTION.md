## The real DevOps challenge solution, by Martín Vedani (martin.vedani@gmail.com)

<a name="index"></a>
### Index

  - [Working with MongDB](#mongo)
  - [Challenge 1. The API returns a list instead of an object](#challenge-1-the-api-returns-a-list-instead-of-an-object)
  - [Challenge 2. Test the application in any cicd system](#challenge-2-test-the-application-in-any-cicd-system)
  - [Challenge 3. Dockerize the APP](#challenge-3-dockerize-the-app)
  - [Challenge 4. Dockerize the database](#challenge-4-dockerize-the-database)
  - [Challenge 5. Docker Compose it](#challenge-5-docker-compose-it)
  - [Final Challenge. Deploy it on kubernetes](#final-challenge-deploy-it-on-kubernetes)

--------------------------------------------------------------------------------------------------------------------------

<a name="mongo"></a>
## Working with MongoDB

Create a local Mongo DB with the restaurants database and restaurant collection.

```bash
$ sudo pip3 install 'mtools[all]'
```

```bash
$ mlaunch init --single
```

```bash
$ mongo --port 27017
```

Create admin user and password to use and turn off MongoDB's initial exception

```bash
> use admin
```

```bash
> db.createUser({
  user: "admin",
  pwd: "admin",
  roles: [ { role: "userAdminAnyDatabase", db: "admin" } ]
});
```

```bash
> exit
```

Confirm login

```bash
$ mongo --port 27017 -u admin -p admin --authenticationDatabase admin
```

```bash
> exit
```

Import restaurant collection

```bash
$ mongoimport --drop -u admin -p admin --authenticationDatabase admin -d restaurant -c restaurant ./data/restaurant.json
```

Confirm database and collection created

```bash
$ mongo --port 27017 -u admin -p admin --authenticationDatabase admin
```

```bash
> use restaurant
```

```bash
> db.restaurant.findOne()
```

```bash
> exit
```

Export the MONGO_URI variable to be able to use the app locally

```bash
$ export MONGO_URI=mongodb://admin:admin@localhost:27017/restaurant?authSource=admin
```

```bash
$ python app.py
```

Confirm working properly on a new shell:

```bash
$ curl localhost:8080/api/v1/restaurant | jq
```

```bash
$ curl localhost:8080/api/v1/restaurant/55f14313c7447c3da705224b | jq
```

--------------------------------------------------------------------------------------------------------------------------

<a name="challenge1"></a>
## Challenge 1. The API returns a list instead of an object

To resolve this challenge, I slightly modified the definition for `restaurant(id)` by adding `try and except` to the app.py python code.

If a restaurant id does exist, it will return the document.

If it does not exit, it will return a code 204 for a successful query to the database where no content was found.

```python
    try:
      restaurants = find_restaurants(mongo, id)
      if restaurants:
        return jsonify(restaurants[0])
    except:
      return('Restaurant id does not exist', 204)
```

And fixed a minor error on src/mongoflask.py (line 30) to be able to search for restaurants by `_id`.

[Back to top](#index)

--------------------------------------------------------------------------------------------------------------------------

<a name="challenge2"></a>
## Challenge 2. Test the application in any cicd system

The `CI/CD | Flask-Mongo Restaurants API tests` are run using GitHub Actions via `.github/workflows/cicd_test.yml`.

```yaml
name: CI/CD | Flask-Mongo Restaurants API
on:
  pull_request:
    branches:
      - "*"
  push:
    branches:
      - "*"

jobs:
  testing:
    runs-on: ubuntu-20.04

    steps:
      - uses: actions/checkout@v3
      - name: Run unit-tests
        run: docker run -v $(pwd):/tmp/app -w /tmp/app --rm painless/tox /bin/bash tox
```

![image](https://user-images.githubusercontent.com/13549294/175773122-41e5d789-59ec-48b6-b746-b3481169d243.png)

[Back to top](#index)

--------------------------------------------------------------------------------------------------------------------------

<a name="challenge3"></a>
## Challenge 3. Dockerize the APP

I created `app.Dockerfile` to dockerize the Flask application with the following command:

```bash
$ docker build -f app.Dockerfile -t intelygenz-flask-app:1.0.0 .
```

[Back to top](#index)

--------------------------------------------------------------------------------------------------------------------------

<a name="challenge4"></a>
## Challenge 4. Dockerize the database

I created `mongodb.Dockerfile` which includes two scripts:

  1) `mongo-init.js` to remove super user privileges from the Flask App; and 
  2) `import_restaurants.sh` to create the required database on first container initiation.

To dockerize the MongoDB, use the following command:

```bash
$ docker build -f mongodb.Dockerfile -t intelygenz-mongo-ddbb:1.0.0 .
```

Next we need to create a network for the Flask App to reach the MongoDB

```bash
docker network create flask-mongo-network
```

Then we can initiate the MongoDB with the following command:

```bash
docker run -d --rm \
    --name mongodb \
    --network flask-mongo-network \
    -e MONGO_INITDB_ROOT_USERNAME=admin \
    -e MONGO_INITDB_ROOT_PASSWORD=admin \
    -e MONGO_INITDB_DATABASE=restaurant \
    -p 27017:27017 \
    intelygenz-mongo-ddbb:1.0.0
```

Finally we can run the application with:

```bash
docker run -d --rm \
    --name flask-app \
    --network flask-mongo-network \
    -e MONGO_URI=mongodb://flask_user:flask_passwd@mongodb:27017/restaurant?authSource=restaurant \
    -p 8080:8080 \
    intelygenz-flask-app:1.0.0
```

Confirm working properly on a new shell:

```bash
$ curl localhost:8080/api/v1/restaurant | jq
```

```bash
$ curl localhost:8080/api/v1/restaurant/55f14313c7447c3da705224b | jq
```

Turn off the containers with the following commands:

```bash
docker stop flask-app
```

```bash
docker stop mongodb
```

[Back to top](#index)

--------------------------------------------------------------------------------------------------------------------------

<a name="challenge5"></a>
## Challenge 5. Docker Compose it

I created `docker-compose.yaml` to docker-compose the full stack (Flask App + MongoDB) with the following command:

```bash
$ docker compose up
```

Confirm working properly on a new shell:

```bash
$ curl localhost:8080/api/v1/restaurant | jq
```

```bash
$ curl localhost:8080/api/v1/restaurant/55f14313c7447c3da705224b | jq
```

Turn everything off and delete containers and network with the following commands:

```bash
$ CTRL + C
```

```bash
$ docker compose down
```

[Back to top](#index)

--------------------------------------------------------------------------------------------------------------------------

<a name="final_challenge"></a>
## Final Challenge. Deploy it on kubernetes

The first thing we will do is publish the images we built for Kubernetes to be able to pull them whenever needed and as many times as necessary.

```bash
$ docker image tag intelygenz-flask-app:1.0.0 martinved/intelygenz-flask-app:1.0.0
```

```bash
$ docker image tag intelygenz-mongo-ddbb:1.0.0 martinved/intelygenz-mongo-ddbb:1.0.0
```

```bash
$ docker push martinved/intelygenz-flask-app:1.0.0
```

```bash
$ docker push martinved/intelygenz-mongo-ddbb:1.0.0
```

### Kubernetes with HELM

Pre-requisites:

> [Install minikube](https://minikube.sigs.k8s.io/docs/start/)

```bash
$ minikube start
```

> [Install Helm 3.7.1 or later](https://helm.sh/docs/intro/install/)

Run `helm version` to verify your version.

```bash
$ helm version
```

Moving forward:

Run Helm's template debugger

```bash
$ helm template --debug k8s_with_Helm/
```

Everything should run smoothly.

Do a dry-test run

```bash
$ helm install test --dry-run --debug ./k8s_with_Helm
```

Everything should run smoothly.

Deploy the stack in kubernetes (`helm install` will do the same as kubctl)

```bash
$ helm install flask-mongo-api ./k8s_with_Helm
```

Confirm release:

```bash
$ helm list
```

Switch namespace for all subsequent kubectl commands in the current project context

```bash
$ kubectl config set-context --current --namespace=flask-mongo-api
```

We need to get the name of the flask pod so that we can forward its port and be able to access ti without exposing it to the exterior

```bash
$ kubectl get pods
```

With the name fo the flask pod, then run the following command to expose it locally

```bash
$ kubectl port-forward <REPLACE_POD_NAME_HERE> 8080:8080
```

Confirm working properly on a new shell:

```bash
$ curl localhost:8080/api/v1/restaurant | jq
```

```bash
$ curl localhost:8080/api/v1/restaurant/55f14313c7447c3da705224b | jq
```

Another way to confirm it all works, is by entering the following into an internet browser - you should see the entire list of restaurants:

<http://localhost:8080/api/v1/restaurant>

Enter the following into an internet browser and you will see ONE of the restaurants:

<http://localhost:8080/api/v1/restaurant/55f14313c7447c3da705224b>

If you want to redeploy everything with Helm, making changes or not, you can run the following command:

```bash
$ helm upgrade --install flask-mongo-api ./k8s_with_Helm
```

Confirm the new release:

```bash
$ helm list
```

Also, confirm with the release history:

```bash
helm history flask-mongo-api
```

Clean everything up by running the following commands:

```bash
$ kubectl config set-context --current --namespace=default
```

```bash
$ helm delete flask-mongo-api
```

```bash
$ docker rmi intelygenz-mongo-ddbb:1.0.0 \
            intelygenz-flask-app:1.0.0 \
            martinved/intelygenz-mongo-ddbb:1.0.0 \
            martinved/intelygenz-flask-app:1.0.0 \
            painless/tox:latest \
            mongo:4.2.21-bionic \
            python:3.9.0-alpine3.12
```

Check and confirm there are no pods left under NAMESPACE flask-mongo-api (the flask pods takes a little time to gracefully shut down)

```bash
$ kubectl get pods -A
```

Stop minikube

```bash
$ minikube stop
```

Done!

[Back to top](#index)

--------------------------------------------------------------------------------------------------------------------------

# END