#!/bin/bash
set -e

echo "..... Create user for db [${MONGO_INITDB_DATABASE}]"
mongo <<EOF
use admin
db.createUser(
  {
    user: "${MONGO_INITDB_USERNAME}",
    pwd: "${MONGO_INITDB_PASSWORD}",
    roles: [
      {
        role: "readWrite",
        db: "${MONGO_INITDB_DATABASE}"
      }
    ]
  }
);
EOF

echo "..... Seed initial restaurants into db [${MONGO_INITDB_DATABASE}]"
mongoimport --username ${MONGO_INITDB_USERNAME} \
    --password ${MONGO_INITDB_PASSWORD} \
    --db ${MONGO_INITDB_DATABASE} \
    --authenticationDatabase admin \
    --collection restaurant \
    --type json \
    --file /docker-entrypoint-initdb.d/restaurant.json 
