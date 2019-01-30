#!/bin/sh


IMAGENAME="quay.io/alex_blazh/the-real-devops-challenge-app"

docker build -t ${IMAGENAME} .
 docker push ${IMAGENAME} 
# there is no reaso to use docker-squash because image is small enough and we don't want to loose adwantages of using layers
