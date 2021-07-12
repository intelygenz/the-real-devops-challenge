# The real DevOps challenge 
Solution developed by Lydia Ramos 

### Challenge 1. The API returns a list instead of an object

Firstly, I've corrected the `find_restaurants` method located in mongoflask.py so it uses the correct ID:
    `query["_id"] = ObjectId(id)` to `query["_id"] = ObjectId(_id)`

Secondly, I have modified the same method so it returns a json object if it finds just one result, a 204 if it doesn't find any restaurant 
that matches the ID or a list of restaurants:

    def find_restaurants(mongo, _id=None):
     query = {}
     if _id:
         query["_id"] = ObjectId(_id)
         result = mongo.db.restaurant.find_one(query)
         if (result is None):
             return 'No content', 204
         else:
             return result
     else:
         return list(mongo.db.restaurant.find(query))

### Challenge 2. Test the application in any cicd system



### Challenge 3. Dockerize the APP

### Challenge 4. Dockerize the database

### Challenge 5. Docker Compose it

### Final Challenge. Deploy it on kubernetes
