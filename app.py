from os import environ

import bson
from bson.json_util import loads
from bson.objectid import ObjectId
from flask import Flask, jsonify
from flask_pymongo import PyMongo

from src.mongoflask  import MongoJSONEncoder, ObjectIdConverter, find_restaurants

if not environ.get("MONGO_URI"):
    raise ValueError("No MONGO_URI set for Flask application")

app = Flask(__name__)
app.config["MONGO_URI"] = environ.get("MONGO_URI")
app.json_encoder = MongoJSONEncoder
app.url_map.converters["objectid"] = ObjectIdConverter
mongo = PyMongo(app)

@app.route("/api/v1/restaurant/status")
def status():
    return jsonify(
        status=200,
        message='Restaurants app lives!'
    )

@app.route("/api/v1/restaurant")
def restaurants():
    restaurants = find_restaurants(mongo)
    return jsonify(restaurants)


@app.route("/api/v1/restaurant/<id>")
def restaurant(id):
    restaurants = find_restaurants(mongo, id)
    if len(restaurants) != 1:
        response = "Error finding the restaurant"
        code = 204        
    else:
        response = restaurants[0]
        code = 200
    return jsonify(response), code    

if __name__ == "__main__":
    app.run(host="0.0.0.0", debug=True, port=8080)
