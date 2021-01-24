[tox]
envlist = py27,py34,py35,py36
skipsdist=True

[testenv]
deps = -rrequirements_dev.txt
commands=pytest
setenv = MONGO_URI = mongodb://test

[development]
deps = -rrequirements_dev.txt
commands=pytest
setenv = MONGO_URI = mongodb://${HOST_ADDRESS}:${HOST_PORT}/${DB_NAME}

[production]
deps = -rrequirements.txt
commands=pytest
setenv = MONGO_URI = mongodb://${DB_USERNAME}:${DB_PASSWORD}@${HOST_ADDRESS}:${HOST_PORT}/?authSource=${DB_NAME}&authMechanism=SCRAM-SHA-256