FROM mongo:4.0.5-xenial
# FROM  mongo:3.4.19-jessie
LABEL autor Oleg Blazhyievskyi <oleg.blazhyievskyi@gmail.com>

COPY restaurant.json /docker-entrypoint-initdb.d/restaurant.json
COPY init-mongo.sh /docker-entrypoint-initdb.d/init-mongo.sh

# CMD mongoimport --host mongo --db restaurant --collection restaurant --type json --file /docker-entrypoint-initdb.d/restaurant.json
