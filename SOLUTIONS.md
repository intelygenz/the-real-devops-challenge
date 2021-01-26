# The real DevOps challenge: Solutions

![Intelygenz](./assets/intelygenz.logo.jpeg)

Here you will found the solutions proposed by **Alejandro Bejarano Gómez** to the real DevOps challenge

### **Challenge 1. The API returns a list instead of an object**
To solve this challenge, i first change the query method to mongodb to obtain a single object instead a list. After that i was facing an http 500 error when i tried with an ID that didn't appears at database. To solve this, i catch the error to transform it in a *null* value and return http 204 when the query was null.

### **Challenge 2. Test the application in any cicd system**
To test the app, we use a python based docker image to test the app in the different tox environments that the app contains.

### **Challenge 3. Dockerize the APP**

To dockerize the APP as lighter as i can i use multi-staging Dockerfile to install dependencies in a build image and after that, copy only the necessary to deploy and launch te app in a smaller image.
Also, we have to launch the docker container with *--network=host* flag because i have my mongodb database in another network, unreachable to docker network.

### **Challenge 4. Dockerize the database**

I couldn't find a way to seed the database on the same Dockerfile, so I had to do a plain Dockerfile with mongodb database and environment configuration, but, i didn't use that actually because i used compose to deploy the mongodb.

### **Challenge 5. Docker Compose it**

I make a docker-compose yaml file with 3 containers. A first container that deploys the mongoDB, a second worker container that seeds it with the restaurants collection and the third container is the api. I also used docker-compose references as I can to make Dockerfiles lightweight, but I had problems with *requirements.txt* in API for example. Also, I have used a secret *.env* file to save the database password and avoid pushing them to the repository thanks to gitignore.