#!/bin/bash

echo "***************************"
echo "** Testing Docker Image ***"
echo "***************************"

docker run -t -v $(pwd):/tmp/app -w /tmp/app --rm painless/tox /bin/bash tox
