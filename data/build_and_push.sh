#!/bin/sh

#There is no reason to automate with CD/CD server building of image with demodata
IMAGENAME="quay.io/alex_blazh/the-real-devops-challenge-mongo:4.0.5-xenial"

docker build -t ${IMAGENAME} .
docker push ${IMAGENAME} 