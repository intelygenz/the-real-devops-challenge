FROM mongo:4.2.21-bionic

# Versioning
LABEL version=1.0.0

# Versioning description
LABEL description="MongoDB | intelygenz/the-real-devops-challenge by Martín Vedani"

# Maintainer
LABEL maintainer="Martín Vedani <martin.vedani@gmail.com>"

# Place files with extensions .sh and .js in /docker-entrypoint-initdb.d to be executed on container start up
COPY data/import_restaurants.sh /docker-entrypoint-initdb.d/
COPY data/restaurant.json /docker-entrypoint-initdb.d/

# Expose port
EXPOSE 27017

# Export Flask App's variables required by mongodb
ARG MONGO_INITDB_ROOT_USERNAME
ARG MONGO_INITDB_ROOT_PASSWORD
ARG MONGO_INITDB_DATABASE

ENV MONGO_INITDB_ROOT_USERNAME=${MONGO_INITDB_ROOT_USERNAME:-root}
ENV MONGO_INITDB_ROOT_PASSWORD=${MONGO_INITDB_ROOT_PASSWORD:-password}
ENV MONGO_INITDB_ROOT_DATABASE=${MONGO_INITDB_DATABASE:-test}
