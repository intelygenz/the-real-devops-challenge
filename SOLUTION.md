# The real DevOps challenge solution, by Martín Vedani (martin.vedani@gmail.com)

<a name="index"></a>
## Index

  - [Challenge 1. The API returns a list instead of an object](#challenge-1-the-api-returns-a-list-instead-of-an-object)
  - [Challenge 2. Test the application in any cicd system](#challenge-2-test-the-application-in-any-cicd-system)
  - [Challenge 3. Dockerize the APP](#challenge-3-dockerize-the-app)
  - [Challenge 4. Dockerize the database](#challenge-4-dockerize-the-database)
  - [Challenge 5. Docker Compose it](#challenge-5-docker-compose-it)
  - [Final Challenge. Deploy it on kubernetes](#final-challenge-deploy-it-on-kubernetes)

--------------------------------------------------------------------------------------------------------------------------

<a name="challenge1"></a>
### Challenge 1. The API returns a list instead of an object


To resolve this challenge, I slightly modified the definition for `restaurant(id)` by adding `try and except` to the app.py python code.

If a restaurant id does exist, it will return the document.

If it does not exit, it will return a code 204 for a successful query to the database where no content was found.

```python
    try:
      restaurants = find_restaurants(mongo, id)
      if restaurants:
        return jsonify(restaurants[0])
    except:
      return('Restaurant id does not exist', 204)
```

[Back to top](#index)

<a name="challenge2"></a>
### Challenge 2. Test the application in any cicd system

[Back to top](#index)

<a name="challenge3"></a>
### Challenge 3. Dockerize the APP

[Back to top](#index)

<a name="challenge4"></a>
### Challenge 4. Dockerize the database

[Back to top](#index)

<a name="challenge5"></a>
### Challenge 5. Docker Compose it

[Back to top](#index)

<a name="final_challenge"></a>
### Final Challenge. Deploy it on kubernetes

[Back to top](#index)