from unittest import TestCase

from bson.objectid import ObjectId
from unittest.mock import patch
import src.mongoflask


def mock_find_restaurant(mongo, id=None):
    data = [
        {"_id": ObjectId("55f14312c7447c3da7051b39"), "URL": "http://www.just-eat.co.uk/restaurants-1awok-pa7/menu", "address": "Unit 2 30 Greenock Road",
         "address line 2": "Bishopton", "name": "1A Wok", "outcode": "PA7", "postcode": "5JN", "rating": 5, "type_of_food": "Chinese"},
        {"_id": ObjectId("55f14312c7447c3da7051b38"), "URL": "http://www.just-eat.co.uk/restaurants-168chinese-ls18/menu", "address": "17 Alexandra Road",
         "address line 2": "West Yorkshire", "name": "168 Chinese & Cantonese Takeaway", "outcode": "LS18", "postcode": "4HE", "rating": 5.5, "type_of_food": "Chinese"},
        {"_id": ObjectId("55f14312c7447c3da7051b37"), "URL": "http://www.just-eat.co.uk/restaurants-1498thespiceaffair-pe11/menu", "address": "Red Lion Hotel",
         "address line 2": "Spalding", "name": "1498 The Spice Affair", "outcode": "PE11", "postcode": "1SU", "rating": 5.5, "type_of_food": "Curry"}
    ]
    return [restaurant for restaurant in data if restaurant.get('_id') == ObjectId(id)]


class TestRestaurant(TestCase):

    @patch('src.mongoflask.find_restaurants')
    def test_get_resturant_returns_a_list(self, mock_restaurant):
        mock_restaurant.side_effect = mock_find_restaurant
        data = src.mongoflask.find_restaurants(None, None)
        self.assertEqual(list, type(data))

    @patch('src.mongoflask.find_restaurants')
    def test_get_resturant_returns_a_list_filtering(self, mock_restaurant):
        mock_restaurant.side_effect = mock_find_restaurant
        data = src.mongoflask.find_restaurants(None, "55f14312c7447c3da7051b39")
        self.assertEqual(list, type(data))

    @patch('src.mongoflask.find_restaurants')
    def test_get_resturant_returns_a_unique_element_list(self, mock_restaurant):
        mock_restaurant.side_effect = mock_find_restaurant
        data = src.mongoflask.find_restaurants(None, "55f14312c7447c3da7051b39")
        self.assertEqual(len(data), 1)
        self.assertTrue(data[0].get("type_of_food") == "Chinese")
