#!/bin/bash
set -e;

mongoimport --host "${MONGO_HOST}" --port 27017 --username "${MONGO_USERNAME}" --password "${MONGO_PASSWORD}" --db "${MONGO_DATABASE}" --collection "${MONGO_DATABASE}" --authenticationDatabase admin --authenticationMechanism=SCRAM-SHA-256 --drop --file /docker-entrypoint-initdb.d/restaurant.json 
