#!/bin/bash

echo "***************************"
echo "** Testing Docker Image ***"
echo "***************************"

docker run -it -v $(pwd):/tmp/app -w /tmp/app --rm painless/tox /bin/bash tox
