# The real DevOps challenge

<a name="index"></a>
## Index

* [Challenge 1. The API returns a list instead of an object](#challenge-1)
* [Challenge 2. Test the application in any cicd system](#challenge-2)
* [Challenge 3. Dockerize the APP](#challenge-3)
* [Challenge 4. Dockerize the database](#challenge-4)
* [Challenge 5. Docker Compose it](#challenge-5)
* [Final Challenge. Deploy it on kubernetes](#kubernetes)
* [Problems found during the challenge](#problems)
    * [Connect string modified](#error-connect-string)
    * [Error found in function `find_restaurants`](#error-function)

<a name="challenge-1"></a>
## Challenge 1. The API returns a list instead of an object

The modifications carried out in the `restaurant(id)` function inside the file `app.py` are these:

```python
@app.route("/api/v1/restaurant/<id>")
def restaurant(id):
    try:
        restaurants = find_restaurants(mongo, id)
        if restaurants:
            return jsonify(restaurants[0])
    except:
        return ('', 204)
```

When is requested an id that does not match any of the values in the database, an exception is thrown. So it is captured, and the function returns a `204` http code.

Also, when an id is found in the database we take the first in the list (`restaurants[0]`) and it is returned as a json object.

[Back to index](#index)

<a name="challenge-2"></a>
## Challenge 2. Test the application in any cicd system

It has been used Github actions to implement the testing of the application. The testing workflow is located in the file [`.github/workflows/testing.yml`](.github/workflows/testing.yml). Tests are run using the docker container. 

The file looks like this:

```yaml
name: Testing restaurant API
on:
  pull_request:
    branches:
      - '*'
  push:
    branches:
      - '*'

jobs:
  testing:
    runs-on: ubuntu-latest

    steps:
    - uses: actions/checkout@v3
    - name: Run unit-tests
      run: docker run -v $(pwd):/tmp/app -w /tmp/app --rm painless/tox /bin/bash tox
```

The tests will be run in every pull request and push in any branch.

[Back to index](#index)


<a name="challenge-3"></a>
## Challenge 3. Dockerize the APP

It is created the Dockerfile `python-app.Dockerfile` for the python application:

```Dockerfile
FROM python:3.9-alpine

WORKDIR /opt/python-app
COPY requirements.txt .

RUN pip install --upgrade pip --no-cache-dir
RUN pip install -r requirements.txt --no-cache-dir

COPY app.py .
COPY ./src ./src/

EXPOSE 8080

CMD ["python3", "-u", "app.py"]
```

To build the image the following command is used:

```
docker build -f python-app.Dockerfile -t python-app .
```

To run de app we will use a network that will be shared between the python-app and the mongo database, since we will start the database as a Docker container. 

To create the network:

```sh
docker network create python-mongo-network
```

To run the python application:

```sh
docker run -d --rm \
    --name python-app \
    -p 8080:8080 \
    --network python-mongo-network \
    --env MONGO_URI="mongodb://mongoadmin:mongoadminpasswd@mongo:27017/intelygenz?authSource=admin" \
    python-app:latest
```

[Back to index](#index)

<a name="challenge-4"></a>
## Challenge 4. Dockerize the database

According to the [Mongo official documentation in Docker Hub](https://hub.docker.com/_/mongo), the files with extensions `.sh` and `.js` that are found in `/docker-entrypoint-initdb.d` will be executed. 

In order to load the restaurant dataset we will need a small script that gets executed when the docker container starts, which will be located at the previous directory. The script will be the following:

```sh
#!/bin/bash

mongoimport \
    -u mongoadmin \
    -p mongoadminpasswd \
    -d intelygenz \
    -c restaurant \
    --authenticationDatabase admin \
    mongodb://localhost:27017 \
    /docker-entrypoint-initdb.d/restaurant.json
```

This script will be placed in the directory `/data` with the `restaurant.json` dataset. The last step will be to make available this script by means of a volumen that will map the `/data` directory with the `/docker-entrypoint-initdb.d` directory from the mongo Docker image.

To make this work from command line, the following command can be used:

```sh
docker run -it --rm --name mongo --network python-mongo-network \
    -e MONGO_INITDB_ROOT_USERNAME=mongoadmin \
    -e MONGO_INITDB_ROOT_PASSWORD=mongoadminpasswd \
    -e MONGO_INITDB_DATABASE=intelygenz \
    -p 27017:27017 \
    -v $(pwd)/data/:/docker-entrypoint-initdb.d/ \
    mongo
```

If the mongo database is needed as an independent image, we can build it with the following Dockerfile 
`mongo.Dockerfile`. 

```Dockerfile
FROM mongo

COPY import.sh /docker-entrypoint-initdb.d/
COPY restaurant.json /docker-entrypoint-initdb.d/

ARG MONGO_INITDB_ROOT_USERNAME
ARG MONGO_INITDB_ROOT_PASSWORD
ARG MONGO_INITDB_DATABASE

ENV MONGO_INITDB_ROOT_USERNAME=${MONGO_INITDB_ROOT_USERNAME:-root}
ENV MONGO_INITDB_ROOT_PASSWORD=${MONGO_INITDB_ROOT_PASSWORD:-password}
ENV MONGO_INITDB_ROOT_DATABASE=${MONGO_INITDB_DATABASE:-test}
```

As it can be seen, default values are set for the root username, root password and database name. So it is encouraged to provide different values at build time for security reasons when the image is built. For example the image can be built with the following command:

```sh
docker build \
    --build-arg MONGO_INITDB_ROOT_USERNAME=mongoadmin \
    --build-arg MONGO_INITDB_ROOT_PASSWORD=mongoadminpasswd \
    --build-arg MONGO_INITDB_DATABASE=intelygenz \
    -t mongo-intelygenz \
    -f mongo.Dockerfile ./data
```

and it can be run with:

```sh
docker run --rm \
    --name mongo \
    --network python-mongo-network \
    -p 27017:27017 \
    mongo-intelygenz
```

[Back to index](#index)

<a name="challenge-5"></a>
## Challenge 5. Docker Compose it

We create a `docker-compose.yml` file that looks like this:

```yaml
version: "3"
services:
  mongo:
    container_name: mongo
    image: mongo
    environment:
      MONGO_INITDB_ROOT_USERNAME: ${MONGO_INITDB_ROOT_USERNAME}
      MONGO_INITDB_ROOT_PASSWORD: ${MONGO_INITDB_ROOT_PASSWORD}
      MONGO_INITDB_DATABASE: ${MONGO_INITDB_DATABASE}
    volumes:
      - ./data/:/docker-entrypoint-initdb.d/
    networks:
      - python-mongo-network

  python-app:
    depends_on:
      - mongo
    build: python-app.Dockerfile
    container_name: python-app
    restart: always
    environment:
      MONGO_URI: ${MONGO_URI}
    ports:
      - 8080:8080
    networks:
      - python-mongo-network

networks:
  python-mongo-network:
    driver: bridge
```

We have externalized the variables values in the `variables.env` file. To make it work we execute the following command:

```sh
docker-compose --env-file variables.env up -d
```


[Back to index](#index)

<a name="kubernetes"></a>
## Final Challenge. Deploy it on kubernetes

The application and database images will be tagged to push them in Docker Hub, in order to make them available for kubernetes. The commands to be run are:

```sh
docker tag python-app:latest amoragon/restaurant-api:v0.1.0
docker tag mongo-intelygenz:latest amoragon/restaurant-mongo:v0.1.0

docker push amoragon/restaurant-api:v0.1.0
docker push amoragon/restaurant-mongo:v0.1.0
```

After pushing the app and the database images to Docker Hub, the following k8s manifest is needed to make available the restaurant API in one deployment.

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    app: restaurant-api
  name: restaurant-api
spec:
  replicas: 1
  selector:
    matchLabels:
      app: restaurant-api
  template:
    metadata:
      labels:
        app: restaurant-api
    spec:
      containers:
      - image: amoragon/restaurant-api:v0.1.0
        name: restaurant-api
        ports:
        - containerPort: 8080
        env:
          - name: MONGO_URI
            value: mongodb://mongoadmin:mongoadminpasswd@localhost:27017/intelygenz?authSource=admin
      - image: amoragon/restaurant-mongo:v0.1.0
        name: mongo
        ports:
        - containerPort: 27017
```

We just need to apply the manifest to run the pod:

```sh
kubectl apply -f deployment-restaurat-api.yaml
```

To check the availavility of the service by means of curl or even the web browser, we make a port-forward like this:

```sh
kubectl port-forward <pod-name> 8080:8080
```

Now it is possible to make a request to the restaurant api at the endpoints:

* `http://localhost:8080/api/v1/restaurant`
* `http://localhost:8080/api/v1/restaurant/{id}`

[Back to index](#index)


<a name="problems"></a>
## Problems found during the challenge

<a name="error-connect-string"></a>
### Connect string modified

In the description the `MONGO_URI` is meant to be this way:

```
MONGO_URI=mongodb://YOUR_USERNAME:YOUR_PASSWORD@YOUR_MONGO_HOST:YOUR_MONGO_PORT/YOUR_MONGO_DB_NAME
```

After using this URI schema, I needed to add `?authSource=admin` at the end, in order to connect to the mongo database. So the MONGO_URI would be:

```
MONGO_URI=mongodb://YOUR_USERNAME:YOUR_PASSWORD@YOUR_MONGO_HOST:YOUR_MONGO_PORT/YOUR_MONGO_DB_NAME?authSource=admin
```

<a name="error-function"></a>
### Error found in function `find_restaurants`

In the file `mongoflask.py`, there is a typo in line 29. So I substitute the original line:

```python
query["_id"] = ObjectId(id)
```

with this one:

```python
query["_id"] = ObjectId(_id)
```

An underscore `_` character needs to be added, to look for the correct field in the database.



