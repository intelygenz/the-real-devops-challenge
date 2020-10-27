### Challenge 1

I decided to create separate method for fetching one specific ID, in order to
make the code cleaner and to improve performance. More specifically:
- The two methods `find_restaurant` and `find_restaurants` are returning
  different instance types (object vs list). Thus the code is now cleaner.
- We avoid the if/else conditions, which makes the retrieval of the result a
  bit faster.
- The new method `find_restaurant` uses the `find_one` method of mongodb to
  run the query, as it needs to return only one item, which also makes the
  retrieval a bit faster.

The alternative would be to check the length of the result, but I believe that
having two methods is much better due to the reasons stated above.

When a restaurant ID is not found, the code now returns 204. I didn't cover the
case where the ID is invalid, which would result in a 500.

Due to the introduction of the new method, I updated the testsuite accordingly.

### Challenge 2

I introduced a `.gitlab-ci.yml` file. It consists of three stages:

- `test`: It consists of a job that runs tox testsuite. More tests could be
  introduced here as well, eg syntax checking and linting tests.
- `install`: It consists of a job that installs the python dependencies of the
  API app in a virtualenv, and then it caches them. This way, the `pip install`
  command won't download and install the dependencies every time, if their
  versions are intact, reducing the build time. Note that the official python
  image does not include virtualenv, thus I created my own docker image that is
  based on the official python image with virtualenv included.
- `build`: It consists of two jobs, one for each docker image (api and
  mongodb). The images are getting built and uploaded to gitlab's private
  registry. Two environment variables `REGISTRY_USER` and `REGISTRY_TOKEN` need
  to be set on gitlab CI environment variables as secrets.

### Challenge 3

The Dockerfile of the API app assumes that the dependencies are already
installed via pip in a virtualenv, as described before. Additionally, the
virtualenv itself is not getting installed on the image, as just by setting the
`VIRTUAL_ENV` environment variable and adjusting the `PATH` is enough.

A new user is created to run the application to add extra security, as no root
permissions are needed.

### Challenge 4

The Dockerfile of the mongodb app is basically the standard image, plus an
extra init script that creates the `restaurants` database, an application db
user, and imports the `restaurants.json` to the db. The init script is
installed in the directory that is documented on the image's dockerhub page.
The appropriate environment variables need to be set up on runtime as
documented there as well.

### Challenge 5

The docker-compose file that I wrote is mainly intended for development/testing
rather than production usage. I left some comments, so that the users can
either use the CI/CD built images from the private registry (or a public
registry), or build the images locally.

For local building, I have created an alternative Dockerfile for the API app,
which runs the `pip install` command as well. This would be much more
convenient for a user who doesn't have access to the private registry or would
want to test something locally fast.

There is room for improvement, for example there could be a secrets file,
instead of hardcoding the secrets, or a persistent volume for the db.

### Challenge 6

There is a new namespace called `restaurants`.

The API app consists of a secrets file (which contains only the `MONGO_URI`
env var), a deployment and a service with NodePort, to be able to bind the port
8080 externally.

The mongodb consists of a secrets file (with the root credentials, and the api
app db user's credentials), a configmap with the db name, a deployment and a
service with ClusterIP, as only the API needs to contact it.

The images used are public ones, as I was having a hard time to be able
to register [kind](https://kind.sigs.k8s.io/) to the private gitlab registry.

There is no persistent volume for the db in this setup.
