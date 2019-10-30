#!/bin/sh
mongo --username "${MONGO_INITDB_ROOT_USERNAME}" \
  --password "${MONGO_INITDB_ROOT_PASSWORD}" \
  <<EOF
use $MONGO_INITDB_DATABASE
db.createUser({
    user: '$MONGO_INITDB_ROOT_USERNAME',
    pwd: '$MONGO_INITDB_ROOT_PASSWORD',
    roles: [{
        role: 'readWrite',
        db: '$MONGO_INITDB_DATABASE'
    }]
})
EOF

mongoimport --username "${MONGO_INITDB_ROOT_USERNAME}" \
  --password "${MONGO_INITDB_ROOT_PASSWORD}" \
  --db "${MONGO_INITDB_DATABASE}" \
  --authenticationDatabase admin \
  --collection restaurant \
  --file /restaurant.json
