mongoimport --drop \
  -u admin -p admin --authenticationDatabase admin \
  -d restaurant -c restaurant \
  /docker-entrypoint-initdb.d/restaurant.json
