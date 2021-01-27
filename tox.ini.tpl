[tox]
envlist = py36
skipsdist=True
skip_missing_interpreters=true
changedir={toxinidir}/tox-test

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
setenv = MONGO_URI = mongodb://${MONGO_NON_ROOT_USERNAME}:${MONGO_NON_ROOT_PASSWORD}@127.0.0.1:27017/${MONGO_INITDB_DATABASE}