import sys
from os import environ

from bson import json_util
from bson.objectid import ObjectId
from flask import Flask, jsonify
from flask_pymongo import PyMongo, BSONObjectIdConverter

from pymongo import MongoClient 
import json

from mongoflask import MongoJSONEncoder, find_restaurants

app = Flask(__name__)
app.config["MONGO_URI"] = environ.get("MONGO_URI_DEV")
app.json_encoder = MongoJSONEncoder
app.url_map.converters["objectid"] = BSONObjectIdConverter
mongo = PyMongo(app)

@app.route("/api/v1/restaurant")
def restaurants():
    restaurants = find_restaurants(mongo)
    return jsonify(restaurants)

@app.route("/api/v1/restaurant/<id>")
def restaurant(id):
    restaurants = find_restaurants(mongo, id)
    return jsonify(restaurants[0])

if __name__ == "__main__":
    try:
        app.run(host="0.0.0.0", debug=True, port=8080)
    except:
        e = sys.exc_info()[0]
        print("Error: {error}".format(error=e))
        raise
    finally:
        print("See you later!")

