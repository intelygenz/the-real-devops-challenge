from unittest import TestCase

from os import environ
from bson.objectid import ObjectId
import mongoflask
from pymongo import MongoClient


mongo = MongoClient(environ.get("MONGO_URI"))

data = [
    {
        "_id": ObjectId("55f14312c7447c3da7051b39"),
        "URL": "http://www.just-eat.co.uk/restaurants-1awok-pa7/menu",
        "address": "Unit 2 30 Greenock Road",
        "address line 2": "Bishopton",
        "name": "1A Wok",
        "outcode": "PA7",
        "postcode": "5JN",
        "rating": 5,
        "type_of_food": "Chinese"
    },
    {
        "_id": ObjectId("55f14312c7447c3da7051b38"),
        "URL": "http://www.just-eat.co.uk/restaurants-168chinese-ls18/menu",
        "address": "17 Alexandra Road",
        "address line 2": "West Yorkshire",
        "name": "168 Chinese & Cantonese Takeaway",
        "outcode": "LS18",
        "postcode": "4HE",
        "rating": 5.5,
        "type_of_food": "Chinese"
    },
    {
        "_id": ObjectId("55f14312c7447c3da7051b37"),
        "URL": "http://www.just-eat.co.uk/restaurants-1498thespiceaffair-pe11/menu",
        "address": "Red Lion Hotel",
        "address line 2": "Spalding",
        "name": "1498 The Spice Affair",
        "outcode": "PE11",
        "postcode": "1SU",
        "rating": 5.5,
        "type_of_food": "Curry"
    },
]

try:
    mongo.db.restaurant.insert_many(data, ordered=False)
except pymongo.errors.BulkWriteError as e:
    pass


class TestRestaurant(TestCase):

    def test_get_resturant_returns_a_list(self):
        data = mongoflask.find_restaurants(mongo, None)
        print(data)
        self.assertEqual(list, type(data))

    def test_get_resturant_returns_a_list_filtering(self):
        data = mongoflask.find_restaurants(mongo, ObjectId("55f14312c7447c3da7051b39"))
        self.assertEqual(list, type(data))

    def test_get_resturant_returns_a_unique_element_list(self):
        data = mongoflask.find_restaurants(mongo, ObjectId("55f14312c7447c3da7051b39"))
        print(data)
        self.assertEqual(len(data), 1)
        self.assertTrue(data[0].get("type_of_food") == "Chinese")
