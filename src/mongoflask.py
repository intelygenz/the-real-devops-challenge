from datetime import date, datetime

import isodate as iso
from bson import ObjectId
from bson.errors import InvalidId
from flask import abort
from flask.json import JSONEncoder

class MongoJSONEncoder(JSONEncoder):
    def default(self, o):
        if isinstance(o, (datetime, date)):
            return iso.datetime_isoformat(o)
        if isinstance(o, ObjectId):
            return str(o)
        else:
            return super().default(o)

def find_restaurants(mongo, _id=None):
    query = {}
    if _id:
        query["_id"] = ObjectId(_id)
        print(query)
    return list(mongo.db.restaurant.find(query))
