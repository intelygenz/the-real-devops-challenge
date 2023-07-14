FROM mongo:latest

COPY data/restaurant.json .
COPY mongo_import.sh /docker-entrypoint-initdb.d/