mongo -- "$MONGO_INITDB_DATABASE" <<EOF
    var rootUser = '$MONGO_INITDB_ROOT_USERNAME';
    var rootPassword = '$(cat "$MONGO_INITDB_ROOT_PASSWORD_FILE")';
    var admin = db.getSiblingDB('admin');
    admin.auth(rootUser, rootPassword);

    var user = '$MONGO_INITDB_USERNAME';
    var passwd = '$(cat "$MONGO_INITDB_PASSWORD_FILE")';
    db.createUser({user: user, pwd: passwd, roles: ["readWrite"]});
EOF

mongoimport -u $MONGO_INITDB_USERNAME -p $(cat "$MONGO_INITDB_PASSWORD_FILE") --db $MONGO_INITDB_DATABASE --collection restaurant --type json --file /config/$MONGO_DATASET