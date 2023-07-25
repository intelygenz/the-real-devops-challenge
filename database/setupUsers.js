db = db.getSiblingDB( 'intelygenz_db' );
db.createUser(
    {
        user: "intelygenz", 
        pwd: "intelygenz_changeme", 
        roles: [
            { role: "readWrite", db:"intelygenz_db" }
        ]
    }
);
