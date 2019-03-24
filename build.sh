#!/bin/bash

echo "****************************"
echo "** Building Docker Image ***"
echo "****************************"

IMAGE="mongo-app"

docker build -t $IMAGE .

