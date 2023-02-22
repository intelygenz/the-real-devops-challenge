"""mongoflask.
Here we manage the classes and functions needed to interact
with mongodb"""

from datetime import date, datetime
import isodate as iso
from bson import ObjectId
from flask.json import JSONEncoder
from werkzeug.routing import BaseConverter

"""MongoJSONEncoder class"""


class MongoJSONEncoder(JSONEncoder):
    """ default function. """
    def default(self, o):
        if isinstance(o, (datetime, date)):
            return iso.datetime_isoformat(o)
        if isinstance(o, ObjectId):
            return str(o)
        return super().default(o)


""" ObjectIdConverter class."""


class ObjectIdConverter(BaseConverter):
    """to_python function."""
    def to_python(self, value):
        return ObjectId(value)
    """to_url function."""
    def to_url(self, value):
        return str(value)


"""find_restaurants function
Input parameters: mongo connection object, optional id parameter
Output: multiple
- json array with all the restaurants if no id is passed
- json object if id is passed and found in mongodb
- 204 if id is passed, but its not available in mongodb"""


def find_restaurants(mongo, _id=None):
    query = {}
    if _id:
        query["_id"] = ObjectId(_id)
        return mongo.db.restaurant.find_one(query)
    return list(mongo.db.restaurant.find(query))
