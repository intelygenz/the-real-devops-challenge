from datetime import date, datetime

from typing import List
import isodate as iso
from bson import ObjectId
from flask.json import JSONEncoder


class MongoJSONEncoder(JSONEncoder):
    def default(self, o):
        if isinstance(o, (datetime, date)):
            return iso.datetime_isoformat(o)
        if isinstance(o, ObjectId):
            return str(o)
        else:
            return super().default(o)


def find_restaurants(mongo, _id=None) -> List:
    query = {}
    if _id:
        query["_id"] = _id
    return list(mongo.db.restaurant.find(query))
