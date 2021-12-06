#/bin/sh

mongoimport \
    --db mongo \
    --collection restaraunt \
    --authenticationDatabase admin \
    --username ${MONGODB_USERNAME} \
    --password ${MONGODB_PASSWORD} \
    --drop --file /code/data/restaraunt.json