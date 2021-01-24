import sys
from os import environ

from bson import json_util
from bson.objectid import ObjectId
from flask import Flask, jsonify
from flask_pymongo import PyMongo, BSONObjectIdConverter

from pymongo import MongoClient 
import json

from src.mongoflask import MongoJSONEncoder, find_restaurants

app = Flask(__name__)
app.config["MONGO_URI"] = environ.get("MONGO_URI")
app.json_encoder = MongoJSONEncoder
app.url_map.converters["objectid"] = BSONObjectIdConverter
mongo = PyMongo(app)

client = MongoClient(environ.get("MONGO_URI_DEV")) 
db = client[environ.get("DB_NAME")]
Collection = db["data"]

with open('data/restaurant.json') as file:
    file_data = json.load(file)

if isinstance(file_data, list): 
    Collection.insert_many(file_data)
else: 
    Collection.insert_one(file_data)


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
        app.run(host="127.0.0.1", debug=True, port=8080)
    except:
        e = sys.exc_info()[0]
        print("Error: {error}".format(error=e))
        raise
    finally:
        print("See you later!")

