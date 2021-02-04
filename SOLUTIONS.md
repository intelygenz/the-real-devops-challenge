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