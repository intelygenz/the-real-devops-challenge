First you should have installed docker daemon and docker-compose. 



You can run tests locally:
```
docker build -t prueba . -f docker/Dockerfile-app
docker run --name python-tests -u $(id -u) --rm -v $(pwd):/workdir prueba tox -e py36
```

run the app
``` 
cd docker
docker-compose up
```

test the challenge:

``` 
curl localhost:8080/api/v1/restaurant/55f14313c7447c3da7052501
```
