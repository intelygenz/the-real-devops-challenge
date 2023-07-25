#!/bin/bash

sleep 10

mongoimport --drop --host mongodb --username root --password changeme --authenticationDatabase admin --db intelygenz_db --collection restaurant --type json --file ./collections/restaurant.json

mongosh --host mongodb --port 27017 --username root --password changeme --authenticationDatabase admin -f setupUsers.js
