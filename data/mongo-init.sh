#!/usr/bin/env sh

# This script is used in order to initialize the mongodb

# Create a new database and user with RW access to the db

mongo --username "${MONGO_INITDB_ROOT_USERNAME}" --password "${MONGO_INITDB_ROOT_PASSWORD}" <<EOF
use restaurants
db.createUser({
  user: '$MONGO_RESTAURANT_USERNAME',
  pwd: '$MONGO_RESTAURANT_PASSWORD',
  roles: [{ role: 'readWrite', db: 'restaurants' }]
})
EOF

# Import the json data to the newly created db, using the previously created user

mongoimport --username "${MONGO_RESTAURANT_USERNAME}" --password "${MONGO_RESTAURANT_PASSWORD}" --db restaurants --authenticationDatabase restaurants --collection restaurant --file /restaurant.json
