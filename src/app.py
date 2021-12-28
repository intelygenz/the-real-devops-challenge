from os import environ

# from bson import json_util
# from bson.objectid import ObjectId
from flask import Flask, jsonify, Response
from flask_pymongo import PyMongo

from mongoflask import MongoJSONEncoder, ObjectIdConverter, find_restaurants

app = Flask(__name__)
app.config["MONGO_URI"] = environ.get("MONGO_URI")
app.json_encoder = MongoJSONEncoder
app.url_map.converters["objectid"] = ObjectIdConverter
mongo = PyMongo(app)


@app.route("/api/v1/restaurant")
def list_restaurants():
    restaurants = find_restaurants(mongo)
    return jsonify(restaurants)


@app.route("/api/v1/restaurant/<id>")
def get_restaurant(restaurant_id):
    restaurant = find_restaurants(mongo, restaurant_id)
    if restaurant is not None:
        return jsonify(restaurant)
    else:
        return Response(f"No match found for {restaurant_id}", status=204, mimetype='application/text')


if __name__ == "__main__":
    app.run(host="0.0.0.0", debug=False, port=8080)
