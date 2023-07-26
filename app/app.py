from os import environ

from bson import json_util
from bson.objectid import ObjectId
from flask import Flask, jsonify, make_response
from flask_pymongo import PyMongo
from pymongo import MongoClient

from src.mongoflask  import MongoJSONEncoder, ObjectIdConverter, find_restaurants

app = Flask(__name__)
app.config["MONGO_URI"] = 'mongodb://' + environ.get('MONGO_USERNAME') + ':' + environ.get('MONGO_USERNAME_PASS') + '@' + environ.get('MONGO_HOST') + ':' + environ.get('MONGO_PORT') + '/' + environ.get('APP_DB')
app.json_encoder = MongoJSONEncoder
app.url_map.converters["objectid"] = ObjectIdConverter
mongo = PyMongo(app)


@app.route("/api/v1/restaurant")
def restaurants():
    restaurants = find_restaurants(mongo)
    return jsonify(restaurants)


@app.route("/api/v1/restaurant/<id>")
def restaurant(id):

    restaurant = find_restaurants(mongo, id)

    if restaurant == []:
        message = jsonify(message='"ID" not match')
        return make_response(message, 204)

    return jsonify(restaurant)

if __name__ == "__main__":
    app.run(host="0.0.0.0", debug=False, port=8080)
