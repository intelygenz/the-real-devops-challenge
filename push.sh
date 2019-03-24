#!/bin/bash

echo "********************"
echo "** Pushing image ***"
echo "********************"

IMAGE_CENTOS="centos-app"
IMAGE_MONGO="mongo-app"
#PASS=*********
#BUILD_TAG=1

echo "*** Logging in ***"
docker login -u dalonsogz20 -p $PASS

echo "*** Tagging image ***"
docker tag $IMAGE_CENTOS:$BUILD_TAG dalonsogz20/$IMAGE_CENTOS:$BUILD_TAG
docker tag $IMAGE_MONGO:$BUILD_TAG dalonsogz20/$IMAGE_MONGO:$BUILD_TAG

echo "*** Pushing image ***"
docker push dalonsogz20/$IMAGE_CENTOS:$BUILD_TAG
docker push dalonsogz20/$IMAGE_MONGO:$BUILD_TAG

