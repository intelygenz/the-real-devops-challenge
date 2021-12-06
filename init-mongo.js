db.createUser(
    {
        user: "hui",
        password: "pizda",
        roles: [
            {
                role: "readWrite",
                db: "mongo"

            }
        ]
    }
)