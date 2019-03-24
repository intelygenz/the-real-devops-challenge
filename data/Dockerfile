FROM mongo:4.0.7-xenial

COPY restaurant.json /docker-entrypoint-initdb.d/restaurant.json
COPY init-mongo.sh /docker-entrypoint-initdb.d/init-mongo.sh

