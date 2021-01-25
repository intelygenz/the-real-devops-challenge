#!/bin/bash
set -e;

# a default non-root role
MONGO_NON_ROOT_ROLE="${MONGO_NON_ROOT_ROLE:-readWrite}"
MONGO_NON_ROOT_USERNAME="${MONGO_NON_ROOT_USERNAME:-igz}"
MONGO_NON_ROOT_PASSWORD="${MONGO_NON_ROOT_PASSWORD:-test}"

"${mongo[@]}" "$MONGO_INITDB_DATABASE" <<-EOJS
	db.createUser({
		user: $(_js_escape "$MONGO_NON_ROOT_USERNAME"),
		pwd: $(_js_escape "$MONGO_NON_ROOT_PASSWORD"),
		roles: [ { role: $(_js_escape "$MONGO_NON_ROOT_ROLE"), db: $(_js_escape "$MONGO_INITDB_DATABASE") } ]
		})
EOJS

mongoimport --username ${MONGO_NON_ROOT_USERNAME} --password ${MONGO_NON_ROOT_PASSWORD} --db ${MONGO_INITDB_DATABASE} --collection ${MONGO_INITDB_DATABASE} --drop --file /docker-entrypoint-initdb.d/restaurant.json 
