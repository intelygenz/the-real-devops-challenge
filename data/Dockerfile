FROM mongo:4.0.8

LABEL MAINTAINER="Jota Bustos"

ADD restaurant.json /mongodata/restaurant.json

ADD init-mongo.sh /docker-entrypoint-initdb.d/init-mongo.sh

WORKDIR /mongodata

EXPOSE 27017

ENV MONGO_INITDB_ROOT_USERNAME=mongodbuser \
    MONGO_INITDB_ROOT_PASSWORD=your_mongodb_root_password \
    MONGO_INITDB_DATABASE=flaskdb \
    MONGODB_DATA_DIR=/data/db \
    MONDODB_LOG_DIR=/dev/null 

CMD [ "mongod", "auth", "--sslMode", "disabled" ]