#!/bin/bash

mongoimport -u mongoadmin -p mongoadminpasswd --authenticationDatabase admin -d intelygenz -c restaurant mongodb://localhost:27017 /docker-entrypoint-initdb.d/restaurant.json
