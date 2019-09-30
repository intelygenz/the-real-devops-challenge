#/bin/sh


# https://stackoverflow.com/questions/42912755/how-to-create-a-db-for-mongodb-container-on-start-up

mongoimport --username $MONGO_INITDB_ROOT_USERNAME \
            --password $MONGO_INITDB_ROOT_PASSWORD \
            --db $MONGO_INITDB_DATABASE \
            --authenticationDatabase admin \
            --collection restaurant \
            --file /dump/restaurant.json

mongo --username $MONGO_INITDB_ROOT_USERNAME \
      --password $MONGO_INITDB_ROOT_PASSWORD <<EOF
use $MONGO_INITDB_DATABASE
db.createUser({
  user:  '$MONGO_APP_USERNAME',
  pwd: '$MONGO_APP_PASSWORD',
  roles: [{
    role: 'readWrite',
    db: '$MONGO_INITDB_DATABASE'
  }]
})
EOF
