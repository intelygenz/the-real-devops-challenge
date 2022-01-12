# PROPOSED SOLUTIONS TO THIS CHALLENGE

Hi IGZ Team, let me present the solutions for this challenge.

### **CHALLENGE 1**
_______

For challenge 1, I have modified the following files:

```bash
./src/mongoflask.py
./src/app.py
./src/mongo_base.py
```

Basically, I found a typo within `mongoflask.py`

```bash
query["_id"] = ObjectId(id) it should have been query["_id"] = ObjectId(_id)
```

Afterwards, I was able to get the response.

In order to get a unique id as an object instead of a list, I have modified `mongoflask.py` as follow:

```bash
def find_restaurants(mongo, _id=None):
    query = {}
    if _id:
        query["_id"] = ObjectId(_id)
        return mongo.db.restaurant.find_one(query)
    return list(mongo.db.restaurant.find(query))
```

Also, I have added an additional file `mongo_base.py` in order to parametrize the host and port for mongodb database:

```bash
from os import environ

MONGO_URI = f'mongodb://{environ.get("MONGO_USERNAME")}:{environ.get("MONGO_PASSWORD")}@' \
            f'{environ.get("MONGO_HOST")}:{environ.get("MONGO_PORT")}/{environ.get("MONGO_INITDB_DATABASE")}'
```

----
### **CHALLENGE 2**
_____

As the repository is hosted in GitHub, I have used GitHub Actions in order to execute the tox process and the build and push of docker images to dockerhub or a third-party registry defined in the secrets

----
### **CHALLENGE 3 AND 4**
_____
I have written three different dockerfiles, one for the app with the application code, another for the mongo database and finally a mongo seed that it's used for seeding the mongo restaurant database. 

The main Dockerfile for the python application is in the root directory.
All configuration for mongo, including shell scripts, Dockerfiles and data to import is organized in a separate folder in order to have a good organization

----
### **CHALLENGE 5**
_____
The docker-compose file ( stack.yml ) builds the images and all containers are deployed in the same network. Enviroment variables are defined using different files
