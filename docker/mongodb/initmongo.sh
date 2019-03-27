#!/bin/bash

mongoimport --host localhost --port 27017 --type json --db $MONGODB_NAME --file /initial-data/restaurant.json