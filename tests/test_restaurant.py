from unittest import TestCase

from bson.objectid import ObjectId
from mock import patch
import src.mongoflask


data = [
    {"_id": ObjectId("55f14312c7447c3da7051b39"), "URL": "http://www.just-eat.co.uk/restaurants-1awok-pa7/menu", "address": "Unit 2 30 Greenock Road",
     "address line 2": "Bishopton", "name": "1A Wok", "outcode": "PA7", "postcode": "5JN", "rating": 5, "type_of_food": "Chinese"},
    {"_id": ObjectId("55f14312c7447c3da7051b38"), "URL": "http://www.just-eat.co.uk/restaurants-168chinese-ls18/menu", "address": "17 Alexandra Road",
     "address line 2": "West Yorkshire", "name": "168 Chinese & Cantonese Takeaway", "outcode": "LS18", "postcode": "4HE", "rating": 5.5, "type_of_food": "Chinese"},
    {"_id": ObjectId("55f14312c7447c3da7051b37"), "URL": "http://www.just-eat.co.uk/restaurants-1498thespiceaffair-pe11/menu", "address": "Red Lion Hotel",
     "address line 2": "Spalding", "name": "1498 The Spice Affair", "outcode": "PE11", "postcode": "1SU", "rating": 5.5, "type_of_food": "Curry"}
]


def mock_find_restaurants(mongo):
    return data

def mock_find_restaurant(mongo, _id):
    result = {}
    for restaurant in data:
        if restaurant.get('_id') == ObjectId(_id):
            result = restaurant
    return result


class TestRestaurant(TestCase):

    @patch('src.mongoflask.find_restaurants')
    def test_find_restaurants_returns_a_list(self, mock_restaurant):
        mock_restaurant.side_effect = mock_find_restaurants
        data = src.mongoflask.find_restaurants(None)
        self.assertEqual(list, type(data))

    @patch('src.mongoflask.find_restaurant')
    def test_find_restaurant_returns_a_dict_filtering(self, mock_restaurant):
        mock_restaurant.side_effect = mock_find_restaurant
        data = src.mongoflask.find_restaurant(None, "55f14312c7447c3da7051b39")
        self.assertEqual(dict, type(data))

    @patch('src.mongoflask.find_restaurant')
    def test_find_restaurant_returns_correct_element(self, mock_restaurant):
        mock_restaurant.side_effect = mock_find_restaurant
        data = src.mongoflask.find_restaurant(None, "55f14312c7447c3da7051b39")
        self.assertEqual(data.get("type_of_food"), "Chinese")

    @patch('src.mongoflask.find_restaurant')
    def test_find_restaurant_returns_empty_dict(self, mock_restaurant):
        mock_restaurant.side_effect = mock_find_restaurant
        data = src.mongoflask.find_restaurant(None, "55f14312c7447c3da7051b40")
        self.assertEqual(data, {})
