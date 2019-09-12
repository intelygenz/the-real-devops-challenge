#!/bin/bash

mongo <<EOF
use admin;
db.auth('root', '123456');
use challenge;
db.createUser({user:'devops',pwd:'devopspass',roles:[{role:'readWrite',db:'challenge'}]});
db.createCollection("restaurant");
EOF

mongoimport --db challenge --collection restaurant --file /restaurant.json --username devops --password=devopspass