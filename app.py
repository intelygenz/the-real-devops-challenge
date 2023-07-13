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


@app.route("/api/v1/restaurant")
def restaurants():
    restaurants = json_util.dumps(find_restaurants(mongo))
    return jsonify(restaurants)


@app.route("/api/v1/restaurant/<id>")
def restaurant(id):
    restaurants = json_util.dumps(find_restaurants(mongo, id))
    if restaurants == "[]":
        return jsonify(restaurants), 204
    else:
        return jsonify(restaurants)
        

if __name__ == "__main__":
    app.run(host="0.0.0.0", debug=False, port=8080)
