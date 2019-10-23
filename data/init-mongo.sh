#!/bin/bash

mongo --username $MONGO_INITDB_ROOT_USERNAME \
      --password $MONGO_INITDB_ROOT_PASSWORD \
      --host localhost \
      --authenticationDatabase admin --eval "\
    db = connect('localhost:27017/admin'); \
    db.auth('$MONGO_INITDB_ROOT_USERNAME', '$MONGO_INITDB_ROOT_PASSWORD'); \
    db = db.getSiblingDB('$MONGO_INITDB_DATABASE'); \
    db.createUser({ \
        user: '$APP_DB_USERNAME', \
        pwd: '$APP_DB_PASSWORD', \
        roles: [{ \
            role: 'readWrite', \
            db: '$MONGO_INITDB_DATABASE' \
        }] \
    })"


mongoimport --username $MONGO_INITDB_ROOT_USERNAME \
            --password $MONGO_INITDB_ROOT_PASSWORD \
            --db $MONGO_INITDB_DATABASE \
            --authenticationDatabase admin \
            --collection restaurant \
            --type json \
            --file /data/restaurant.json