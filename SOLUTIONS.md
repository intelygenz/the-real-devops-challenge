# Solutions to DevOps challenge


## Challenge 1. The API returns a list instead of an object

* When the endpoint `/api/v1/restaurant/<id>` is hit, it calls the `find_restaurants` method in the [mongoflask](https://github.com/husker-du/the-real-devops-challenge/blob/master/src/mongoflask.py) module, which returns a list of objects either a restaurant identifier is provided or not.

* Given a restaurant identifier `id`, the service should find only one restaurant in the mongo database and return a single object containing the restaurant data.

* If no identifier is provided, a list of all the restaurants stored in the database must be returned.

* The new code for the `find_restaurants` method is as follows:

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

```shell
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
```
The HTML publisher plugin is used to publish the coverage reports to the Jenkins job.

<p>&nbsp;</p>

## Challenge 3. Dockerize the APP
* A [Dockerfile](https://github.com/husker-du/the-real-devops-challenge/blob/master/restaurantapi/Dockerfile) is created in order to create an image that can create containers that run the flask api to access the restaurant data from a mongo database.

```dockerfile
    # set base image (host OS)
    FROM python:3.9.1-alpine

    # set the working directory in the container
    WORKDIR /usr/src/app

    # copy the dependencies file to the working directory
    COPY requirements.txt .

    # install dependencies
    RUN pip install -r requirements.txt

    # copy the content of the local src directory to the working directory
    COPY app.py .
    COPY src/ ./src

    # the api listens on this port
    EXPOSE 8080

    # run the container as a non-root user
    RUN addgroup -S foodie && adduser -S foodie -G foodie
    USER foodie

    # command to run on container start
    CMD [ "python", "app.py" ]
```

* Execute the following command in the root directory of the project to build this dockerfile and generate a docker container image named `ctomas65/restaurantapi`:

```shell
    $ docker build -t ctomas65/restaurantapi -f restaurantapi/Dockerfile .
```

* And for running the restaurant API in a docker container:

```shell
    $ export MONGO_URI=mongodb://foodie:foodie@localhost:27017/restaurantdb?authSource=admin

    $ docker run -d --rm -e MONGO_URI=${MONGO_URI} -p 8080:8080 --name restaurantapi ctomas65/restaurantapi
      * Serving Flask app "app" (lazy loading)
      * Environment: production
        WARNING: This is a development server. Do not use it in a production deployment.
        Use a production WSGI server instead.
      * Debug mode: off
      * Running on http://0.0.0.0:8080/ (Press CTRL+C to quit)
```

* The API service is listening at port 8080 in the host, which redirects to port 8080 in the container. At this moment, if we try to hit the restaurant API, it will return the following error message:

```shell
    $ curl localhost:8080/api/v1/restaurant
      <!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 3.2 Final//EN">
      <title>500 Internal Server Error</title>
      <h1>Internal Server Error</h1>
      <p>The server encountered an internal error and was unable to complete your request. Either the server is overloaded or there is an error in the application.</p>

    $ docker logs restaurantapi
      ...
      pymongo.errors.ServerSelectionTimeoutError: localhost:27017: [Errno 111] Connection refused, Timeout: 30s, Topology Description: <TopologyDescription id: 60180edeb6f16da1b630279f, topology_type: Single, servers: [<ServerDescription ('localhost', 27017) server_type: Unknown, rtt: None, error=AutoReconnect('localhost:27017: [Errno 111] Connection refused')>]>
```

This is due to the fact that there is no mongo database running. As we can see, the api docker container is working properly: it receives the request and tries to connect to the database, but no database is found. 

* In the next challenge, a mongo database will be run using a mongodb docker container.

<p>&nbsp;</p>

## Challenge 4. Dockerize the database
* No dockerfile is needed to run the mongo database in a container. A mongo image is available in the docker hub. We only have to configure mongo with our user and database and seed it with the restaurant data in the [restaurant.json](https://github.com/husker-du/the-real-devops-challenge/blob/master/mongo/data/restaurant.json) file.

* The mongo container image provides the /docker-entrypoint-initdb.d/ path to deploy custom .js or .sh setup scripts that will be run once on database initialisation when there is nothing populated in the `/data/db` directory. An initialization script [mongo-init.sh](https://github.com/husker-du/the-real-devops-challenge/blob/master/mongo/mongo-init.sh) creates a user `foodie` for the `restaurantdb` database and seeds the data in the [restaurant.json](https://github.com/husker-du/the-real-devops-challenge/blob/master/mongo/data/restaurant.json) into the `restaurant` collection of the `restaurantdb` database by executing the `mongoimport` command as shown below:

```bash
    #!/bin/bash
    set -e

    echo "..... Create user for db [${MONGO_INITDB_DATABASE}]"
    mongo <<EOF
    use admin
    db.createUser(
      {
        user: "${MONGO_INITDB_USERNAME}",
        pwd: "${MONGO_INITDB_PASSWORD}",
        roles: [
          {
            role: "readWrite",
            db: "${MONGO_INITDB_DATABASE}"
          }
        ]
      }
    );
    EOF

    echo "..... Seed initial restaurants into db [${MONGO_INITDB_DATABASE}]"
    mongoimport --username ${MONGO_INITDB_USERNAME} \
        --password ${MONGO_INITDB_PASSWORD} \
        --db ${MONGO_INITDB_DATABASE} \
        --authenticationDatabase admin \
        --collection restaurant \
        --type json \
        --file /docker-entrypoint-initdb.d/restaurant.json 
```
*  .js scripts will be run against `test` by default or `MONGO_INITDB_DATABASE` if defined in the environment.
  
* Taking into account all these considerations, a mongodb docker container is started up by executing this command:

```shell
    $ docker run -d --rm \
        -e MONGO_INITDB_ROOT_USERNAME=root \
        -e MONGO_INITDB_ROOT_PASSWORD=root \
        -e MONGO_INITDB_DATABASE=restaurantdb \
        -e MONGO_INITDB_USERNAME=foodie \
        -e MONGO_INITDB_PASSWORD=foodie \
        -p 27017:27017 \
        -v $(pwd)/mongo/mongo-init.sh:/docker-entrypoint-initdb.d/mongo-init.sh:ro \
        -v $(pwd)/mongo/data/restaurant.json:/docker-entrypoint-initdb.d/restaurant.json:ro \
        -v /data/db \
        --name mongodb mongo:4.4.3
```

* This command starts up a docker container from the `mongo:4.4.3` image, a name for the initial database and the username and password for the root user and this initial database is passed to the container through environment variables. The docker is listening on host port `27017` to the docker interal port `27017`. The initialisation script [mongo-init.sh](https://github.com/husker-du/the-real-devops-challenge/blob/master/mongo/mongo-init.sh) and the data file [restaurant.json](https://github.com/husker-du/the-real-devops-challenge/blob/master/mongo/data/restaurant.json) are bound to the `/docker-entrypoint-initdb.d` directory in the mongodb container. Persistent data in the mongodb container `/data/db` is managed by docker.

* Having this mongodb docker container running, the restaurant api can be started and linked to the mongodb database container (by using the `--link mongodb` option) to access its data:

```
    $ docker run -d --rm -e MONGO_URI=${MONGO_URI} -p 8080:8080 --link mongodb --name restaurantapi ctomas65/restaurantapi
```

* Now, by hitting the restaurant API, we successfully get the restaurant data from the mongo database:

```bash
    $ curl localhost:8080/api/v1/restaurant/55f14313c7447c3da705224b | jq
      % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                     Dload   Upload  Total   Spent    Left  Speed
    100   239  100   239    0     0   8535      0 --:--:-- --:--:-- --:--:--  8535
    {
      "URL": "http://www.just-eat.co.uk/restaurants-bayleaf-de75/menu",
      "_id": "55f14313c7447c3da705224b",
      "address": "39 Market Street",
      "address line 2": "Heanor",
      "name": "Bayleaf",
      "outcode": "DE75",
      "postcode": "7NR",
      "rating": 5,
      "type_of_food": "Curry"
    }
```

<p>&nbsp;</p>

## Challenge 5. Docker Compose it

* The following [docker-compose.yaml](https://github.com/husker-du/the-real-devops-challenge/blob/master/docker-compose.yaml) file orchestrates the containers of the mongodb database and the restaurant api.

```yaml
    version: '3.8'

    services:
      mongodb:
        image: mongo:4.4.3
        container_name: mongodb
        hostname: mongodb
        environment:
          MONGO_INITDB_ROOT_USERNAME: ${MONGO_INITDB_ROOT_USERNAME}
          MONGO_INITDB_ROOT_PASSWORD: ${MONGO_INITDB_ROOT_PASSWORD}
          MONGO_INITDB_DATABASE: ${MONGO_INITDB_DATABASE}
          MONGO_INITDB_USERNAME: ${MONGO_INITDB_USERNAME}
          MONGO_INITDB_PASSWORD: ${MONGO_INITDB_PASSWORD}
        ports:
          - ${MONGO_PORT}:27017
        volumes:
          - ./mongo/mongo-init.sh:/docker-entrypoint-initdb.d/mongo-init.sh:ro
          - ./mongo/data/restaurant.json:/docker-entrypoint-initdb.d/restaurant.json:ro
          - mongo-volume:/data/db
        restart: unless-stopped

      restaurantapi:
        build:
          context: .
          dockerfile: ./restaurantapi/Dockerfile
        container_name: restaurantapi
        hostname: restaurantapi
        environment:
          MONGO_URI: ${MONGO_URI}
        ports:
          - ${API_PORT}:8080
        restart: unless-stopped
        depends_on:
          - mongodb

    volumes:
      mongo-volume:
```

* The environment variables are set in a [.env](https://github.com/husker-du/the-real-devops-challenge/blob/master/.env.example) file:

```properties
    # MongoDB
    MONGO_INITDB_ROOT_USERNAME = root
    MONGO_INITDB_ROOT_PASSWORD = root
    MONGO_INITDB_DATABASE = restaurantdb
    MONGO_INITDB_USERNAME = foodie
    MONGO_INITDB_PASSWORD = foodie
    MONGO_PORT = 27017

    # Flask API server
    API_PORT = 8008
    MONGO_URI = mongodb://${MONGO_INITDB_USERNAME}:${MONGO_INITDB_PASSWORD}@mongodb:27017/${MONGO_INITDB_DATABASE}?authSource=admin
```

<p>&nbsp;</p>

## Final Challenge. Deploy it on kubernetes

* I'm not going to use neither `minikube` nor `microk8s` to run our restaurant service on kubernetes. I'll use an EKS kubernetes cluster provided by AWS which is a more realistic situation. This cluster will be generated using the `eksctl` command (which creation is out of the scope of this document), but there are many other methods to build a kubernetes cluster using `terraform`, `ansible`, `vagrant`, etc.

* First of all, the `ctomas65/restaurantapi` image must be pushed to a remote repository (in my case, to the `docker.io` hub) so that the kubernetes pods that runs the restaurant API containers could pull this image:

```
    $ docker tag ctomas65/restaurantapi:latest ctomas65/restaurantapi:v1
    $ docker push ctomas65/restaurantapi:v1
    $ docker push ctomas65/restaurantapi:latest
```

* The following picture depicts the architecture of the kubernetes deployment solution:

![Kubernetes Solution](assets/kubernetes_solution.png)

* Previously to the creation of the kubernetes resources, we must provide the configuration to the application containers by creating several **ConfigMap** and **Secret** resources:
```
    $ kubectl create configmap mongodb-config \
          --from-env-file=config_files/mongodb/.env

    $ kubectl create configmap mongodb-init \
          --from-file=config_files/mongodb/mongo-init.sh \
          --from-file=restaurant.json

    $ kubectl create secret generic mongodb-secrets \
          --from-literal=MONGO_INITDB_ROOT_PASSWORD='root' \
          --from-literal=MONGO_INITDB_PASSWORD='foodie'

    $ kubectl create configmap restapi-config \
          --from-env-file=config_files/restapi/.env

    $ kubectl create secret generic restapi-secrets \
          --from-literal=MONGO_URI='mongodb://foodie:foodie@mongodb-svc:27017/restaurantdb?authSource=admin'
```

* A **StorageClass** must be created to dinamically provide persistent volumes. This is defined in the [kube-storageclass.yaml](https://github.com/husker-du/the-real-devops-challenge/blob/master/kubernetes/kube-storageclass.yaml) manifest:

```yaml
    apiVersion: storage.k8s.io/v1
    kind: StorageClass
    metadata:
      name: standard
      labels:
        app: restaurant
    provisioner: kubernetes.io/aws-ebs
    parameters:
      type: gp2
      fstype: ext4
      zone: eu-west-2b
    reclaimPolicy: Delete
    allowVolumeExpansion: true
    mountOptions:
      - debug
    volumeBindingMode: Immediate
```

* In the manifest file [kube-mongodb.yaml](https://github.com/husker-du/the-real-devops-challenge/blob/master/kubernetes/kube-mongodb.yaml)

```yaml
    apiVersion: v1
    kind: Service
    metadata:
      name: mongodb-svc
      labels:
        app: restaurant
    spec:
      ports:
        - port: 27017
      selector:
        app: restaurant
        tier: mongodb
      clusterIP: None

    ---
    apiVersion: v1
    kind: PersistentVolumeClaim
    metadata:
      name: mongodb-pvc
      labels:
        app: restaurant
    spec:
      storageClassName: standard
      accessModes:
        - ReadWriteOnce
      resources:
        requests:
          storage: 10Gi

    ---
    apiVersion: v1
    kind: ReplicationController
    metadata:
      name: mongodb-rc
      labels:
        app: restaurant
    spec:
      replicas: 1
      selector:
          app: restaurant
          tier: mongodb
      template:
        metadata:
          name: mongodb
          labels:
            app: restaurant
            tier: mongodb
        spec:                                                     
          containers:
            - name: mongodb
              image: mongo:4.4.3
              envFrom:
                - configMapRef:
                    name: mongodb-config
                - secretRef:
                    name: mongodb-secrets
              ports:
                - containerPort: 27017
                  name: mongodb
              volumeMounts:
                - name: mongodb-persistent
                  mountPath: /data/db
                - name: initdb
                  mountPath: /docker-entrypoint-initdb.d
                  readOnly: true
          volumes:
            - name: mongodb-persistent
              persistentVolumeClaim:
                claimName: mongodb-pvc
            - name: initdb
              configMap:
                name: mongodb-init
```

* The declarative file [kube-restapi.yaml](https://github.com/husker-du/the-real-devops-challenge/blob/master/kubernetes/kube-restapi.yaml) describes the components to be created for the restaurant API flask server:

```yaml
    apiVersion: v1
    kind: Service
    metadata:
      name: restapi-svc
      labels:
        app: restaurant
    spec:
      type: LoadBalancer
      ports:
        - port: 8008
          targetPort: 8080
      selector:
        app: restaurant
        tier: flaskapi

    ---
    apiVersion: apps/v1
    kind: Deployment
    metadata: 
      name: restapi-deploy
      labels:
        app: restaurant
    spec:
      replicas: 3
      minReadySeconds: 10
      strategy:
        type: RollingUpdate
        rollingUpdate: 
          maxSurge: 1
          maxUnavailable: 0
      selector:
        matchLabels:
          app: restaurant
          tier: flaskapi
      template:
        metadata:
          name: restapi
          labels:
            app: restaurant
            tier: flaskapi
        spec:
          containers:
            - name: restaurantapi
              image: ctomas65/restaurantapi:v1
              envFrom:
                - configMapRef:
                    name: restapi-config
                - secretRef:
                    name: restapi-secrets
              ports:
                - containerPort: 8080
                  name: http
```

* In order to build this architeture, run this command in the `kubernetes` folder:

```
    $ kubectl apply -f kube-storageclass.yml -f kube-mongodb.yaml -f kube-restapi.yaml
```

* Just to get the external IP address provided by the LoadBalancer service:

```
  $ kubectl describe svc restapi-svc

    ...
    LoadBalancer Ingress:     a56d95789c7b840d899b6ed16423df3f-1282384288.eu-west-2.elb.amazonaws.com
    Port:                     <unset>  8008/TCP
    ...
```

* By hitting this external IP address on port **8008** to get the restaurant data from the mongo database:

```
    $ curl a56d95789c7b840d899b6ed16423df3f-1282384288.eu-west-2.elb.amazonaws.com:8008/api/v1/restaurant/55f14313c7447c3da705224b | jq

      % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                    Dload  Upload   Total   Spent    Left  Speed
    100   239  100   239    0     0   1106      0 --:--:-- --:--:-- --:--:--  1106
    {
      "URL": "http://www.just-eat.co.uk/restaurants-bayleaf-de75/menu",
      "_id": "55f14313c7447c3da705224b",
      "address": "39 Market Street",
      "address line 2": "Heanor",
      "name": "Bayleaf",
      "outcode": "DE75",
      "postcode": "7NR",
      "rating": 5,
      "type_of_food": "Curry"
    }
```
