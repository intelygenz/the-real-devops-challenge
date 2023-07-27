#!/bin/bash

sleep 10

mongoimport --drop --host $MONGO_HOST --port $MONGO_PORT --username $ROOT_USERNAME --password $ROOT_PASSWORD --authenticationDatabase $AUTH_DB --db $APP_DB --collection restaurant --type json --file ./collections/restaurant.json

cat <<EOF > user.js
db = db.getSiblingDB( '$APP_DB' );
db.createUser(
    {
        user: '$MONGO_USERNAME',
        pwd: '$MONGO_USERNAME_PASS', 
        roles: [
            { role: "readWrite", db: '$APP_DB' }
        ]
    }
);
EOF

mongosh --host $MONGO_HOST --port $MONGO_PORT --username $ROOT_USERNAME --password $ROOT_PASSWORD --authenticationDatabase $AUTH_DB  --file ./user.js

