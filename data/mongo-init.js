db.createUser(
  {
    user: "flask_user",
    pwd: "flask_passwd",
    roles: [
      {
        role: "read",
        db: "restaurant"
      }
    ]
  }
);