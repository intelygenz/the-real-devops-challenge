# The real DevOps challenge: Solutions

![Intelygenz](./assets/intelygenz.logo.jpeg)

Here you will found the solutions proposed by **Alejandro Bejarano Gómez** to the real DevOps challenge

### Challenge 1. The API returns a list instead of an object
To solve this challenge, i first change the query method to mongodb to obtain a single object instead a list. After that i was facing an http 500 error when i tried with an ID that didn't appears at database. To solve this, i catch the error to transform it in a *null* value and return http 204 when the query was null.
