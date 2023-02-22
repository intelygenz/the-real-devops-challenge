"""Main application."""

from os import environ
from bson import json_util
from bson.objectid import ObjectId
from flask import Flask, jsonify
from flask_pymongo import PyMongo
from src.mongoflask  import MongoJSONEncoder, ObjectIdConverter, find_restaurants

app = Flask(__name__)
app.config["MONGO_URI"] = environ.get("MONGO_URI")

app.json_encoder = MongoJSONEncoder
app.url_map.converters["objectid"] = ObjectIdConverter
mongo = PyMongo(app)


@app.route("/api/health")
def health():
    """Healthcheck
    Input parameters: none
    Output: json array with all the restaurants in the dataset.
    """
    return '', 200

@app.route("/api/v1/restaurant")
def restaurants():
    """Restaurants function
    Input parameters: none
    Output: json array with all the restaurants in the dataset.
    """
    restaurants = find_restaurants(mongo)
    return jsonify(restaurants)

@app.route("/api/v1/restaurant/<id>")
def restaurant(id):
    """Restaurants function
    Input parameters: string with the restaurant id
    Output: json object with the restaurant data if available, 204 otherwise.
    """
    restaurants = find_restaurants(mongo, id)
    if restaurants != None:
        return jsonify(restaurants)
    else:
        return '', 204

if __name__ == "__main__":
    app.run(host="0.0.0.0", debug=False, port=8080)
