from os import environ
import logging
from bson.objectid import ObjectId
from bson.errors import InvalidId
from flask import Flask, jsonify, abort
from flask_pymongo import PyMongo
from typing import List, Dict
from pymongo import MongoClient, errors

from mongoflask import MongoJSONEncoder, find_restaurants

app = Flask(__name__)
app.config["MONGO_URI"] = environ.get("MONGO_URI")
app.json_encoder = MongoJSONEncoder
mongo = PyMongo(app)
logging.basicConfig(format='%(process)d %(levelname)s %(message)s')


@app.route("/health")
def readiness():
    return "OK", 200


@app.route("/live")
def liveness():
    try:
        connection = MongoClient(environ.get("MONGO_URI"),
                                 serverSelectionTimeoutMS=2000)
        connection.admin.command('ping')
    except (errors.ServerSelectionTimeoutError,
            errors.ConnectionFailure,
            errors.ExecutionTimeout) as e:
        logging.error('Database connection error: %s', e)
        return "ERROR", 500
    return "OK", 200


@app.route("/api/v1/restaurant")
def restaurants() -> List:
    restaurants = find_restaurants(mongo)
    return jsonify(restaurants)


@app.route("/api/v1/restaurant/<id>")
def restaurant(id) -> Dict:
    try:
        restaurants = find_restaurants(mongo, ObjectId(id))
    except (InvalidId, TypeError):
        logging.error("Not a valid ObjectId.")
        abort(500)

    if not restaurants:
        abort(404)
    return jsonify(restaurants[0])


@app.errorhandler(404)
def not_found(e) -> Dict:
    return dict(Error="ID not found"), 404


@app.errorhandler(500)
def error(e) -> Dict:
    return dict(Error="ID not valid"), 500


if __name__ == "__main__":
    app.run(host="0.0.0.0", debug=False, port=8080)
