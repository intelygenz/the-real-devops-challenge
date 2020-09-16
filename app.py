from os import environ

from bson import json_util
from bson.objectid import ObjectId
from flask import Flask, jsonify
from flask_pymongo import PyMongo

from src.mongoflask  import MongoJSONEncoder, ObjectIdConverter, find_restaurants

app = Flask(__name__)
app.config["MONGO_URI"] = 'mongodb://' + environ.get('MONGODB_USERNAME') + ':' + environ.get('MONGODB_PASSWORD') + '@' + environ.get('MONGODB_HOSTNAME') + ':27017/' + environ.get('MONGODB_DATABASE')
app.json_encoder = MongoJSONEncoder
app.url_map.converters["objectid"] = ObjectIdConverter
mongo = PyMongo(app)

@app.route("/")
def index():
    return jsonify(
        status=True,
        message='Welcome to the Flask App of The Real Devops Challenge!'
    )

@app.route("/api/v1/restaurant")
def restaurants():
    restaurants = find_restaurants(mongo)
    return jsonify(restaurants)


@app.route("/api/v1/restaurant/<id>")
def restaurant(id):
    restaurants = find_restaurants(mongo, id)
    if len(restaurants) > 0:
        res = restaurants[0]
        code = 200
    else:
        res = "No Content"
        code = 204
    return jsonify(res), code

if __name__ == "__main__":
    app.run(host="0.0.0.0", debug=False, port=8080)
