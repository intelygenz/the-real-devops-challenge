MKFILE_DIR := $(abspath $(patsubst %/,%,$(dir $(abspath $(lastword $(MAKEFILE_LIST))))))
CONTAINER_NAME ?= devopschallenge
IMAGE_NAME ?= rbarrett/devopschallenge
IMAGE_TAG ?= latest


.PHONY: container 
container:
	docker build -t ${IMAGE_NAME} .

.PHONY: cluster
cluster:
	docker compose up 
	
.PHONY: mongo
mongo:
	docker pull mongo:latest

.PHONY: scan
scan:
	docker scan ${IMAGE_NAME}

.PHONY: test
test: 
	docker run --env MONGO_URI="mongodb://my-mongo.org" ${IMAGE_NAME}

.PHONY: tox
tox:
	docker run -it -v $(pwd):/tmp/app -w /tmp/app --rm painless/tox /bin/bash tox