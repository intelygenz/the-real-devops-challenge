### Challenge 1. The API returns a list instead of an object
- In the **src/mongoflask.pY** file, the objectID **"_id"** is configured in the **find_restaurants** function since it previously pointed to a key that did not exist and therefore the object that returned the query was empty.

- In the **restaurant function** located in the **app.py** file, it is adapted so that if the query does not find an _id in the database, it returns a 204

### Challenge 2. Test the application in any cicd system

- The CICD flow in with github-actions and is located in the path .github/workflows/
- The pipeline performs the following stages:
    
    1. Checkout source code.
    2. Run the tests with tox.
    3. Build docker images.
    4. Publish docker images in hub.docker.com

### Challenge 3. Dockerize the APP

- APP is imaged with python 3.6 and adapts parts of the code so that it can work with variables and thus avoid adding hardcoded values.

### Challenge 4. Dockerize the database

- A mongo seed is dockerized to do the injection of the data and the user to make the database more general and usable in other projects (this would not be an optimal solution for a good architecture).

### Challenge 5. Docker Compose it
- A docker-compose is created with the application, the mongo database and a mongo seed to inject the data and a specific user for the database to be used.

### Final Challenge. Deploy it on kubernetes
- All the necessary manifests are created to be able to deploy the application so that it works in minikube.