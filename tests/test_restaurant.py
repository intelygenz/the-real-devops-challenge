from unittest import TestCase
from os import environ

from flask import Flask
from flask_pymongo import PyMongo

import src.mongoflask


class TestRestaurant(TestCase):
    app = Flask('TestRestaurant')
    app.config["MONGO_URI"] = environ.get("TEST_MONGO_URI")
    mongo = PyMongo(app)

    def test_get_restaurant_returns_a_list(self):
        data = src.mongoflask.find_restaurants(self.mongo, None)
        self.assertEqual(list, type(data))
        self.assertEqual(len(data), 3)

    def test_get_restaurant_returns_a_list_filtering(self):
        data = src.mongoflask.find_restaurants(self.mongo, "55f14312c7447c3da7051b39")
        self.assertEqual(list, type(data))
        self.assertEqual(len(data), 1)

    def test_get_restaurant_returns_a_unique_element_list(self):
        data = src.mongoflask.find_restaurants(self.mongo, "55f14312c7447c3da7051b39")
        self.assertEqual(len(data), 1)
        self.assertTrue(data[0].get("type_of_food") == "Chinese")
