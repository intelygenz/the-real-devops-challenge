#!/usr/bin/env bash
set -e;

# a default non-root role
MONGO_ROLE="${MONGO_ROLE:-readWrite}"
MONGO_USERNAME="${MONGO_USERNAME:-test}"
MONGO_PASSWORD="${MONGO_PASSWORD:-test}"

"${mongo[@]}" "$MONGO_INITDB_DATABASE" <<-JS
	db.createUser({
		user: $(_js_escape "$MONGO_USERNAME"),
		pwd: $(_js_escape "$MONGO_PASSWORD"),
		roles: [ { role: $(_js_escape "$MONGO_ROLE"), db: $(_js_escape "$MONGO_INITDB_DATABASE") } ]
		})
JS