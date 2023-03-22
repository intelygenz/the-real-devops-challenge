### Challenge 1. The API returns a list instead of an object
def restaurant(id):
    restaurants = find_restaurants(mongo, id)
    return jsonify(list(restaurants)[0])
def restaurants():
    restaurants = find_restaurants(mongo)
    return jsonify(list(restaurants))

def find_restaurants(mongo, _id=None):
    query = {}
    if _id:
        query["_id"] = ObjectId(_id)
    result = mongo.db.restaurant.find(query)
    if _id == None:
        result = list(result)        
    return mongo.db.restaurant.find(query)

- se utiliza list antes de hacer jsonify para que convierta el objeto en una lista
- en el resultado de un solo restaurante se coje el primer elemento de la lista
- en la funcion find_restaurants transformamos _id en ObjectId