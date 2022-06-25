## The real DevOps challenge solution, by Martín Vedani (martin.vedani@gmail.com)

<a name="index"></a>
## Index

  - [Working with MongDB](#mongo)
  - [Challenge 1. The API returns a list instead of an object](#challenge-1-the-api-returns-a-list-instead-of-an-object)
  - [Challenge 2. Test the application in any cicd system](#challenge-2-test-the-application-in-any-cicd-system)
  - [Challenge 3. Dockerize the APP](#challenge-3-dockerize-the-app)
  - [Challenge 4. Dockerize the database](#challenge-4-dockerize-the-database)
  - [Challenge 5. Docker Compose it](#challenge-5-docker-compose-it)
  - [Final Challenge. Deploy it on kubernetes](#final-challenge-deploy-it-on-kubernetes)

--------------------------------------------------------------------------------------------------------------------------

<a name="mongo"></a>
### Working with MongoDB

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

On a new shell:

```bash
$ curl localhost:8080/api/v1/restaurant | jq
```

```bash
$ curl localhost:8080/api/v1/restaurant/55f14313c7447c3da705224b | jq
```

--------------------------------------------------------------------------------------------------------------------------

<a name="challenge1"></a>
### Challenge 1. The API returns a list instead of an object

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
### Challenge 2. Test the application in any cicd system

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
### Challenge 3. Dockerize the APP

[Back to top](#index)

--------------------------------------------------------------------------------------------------------------------------

<a name="challenge4"></a>
### Challenge 4. Dockerize the database

[Back to top](#index)

--------------------------------------------------------------------------------------------------------------------------

<a name="challenge5"></a>
### Challenge 5. Docker Compose it

[Back to top](#index)

--------------------------------------------------------------------------------------------------------------------------

<a name="final_challenge"></a>
### Final Challenge. Deploy it on kubernetes

[Back to top](#index)

--------------------------------------------------------------------------------------------------------------------------
