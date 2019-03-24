#!/bin/bash

find -name '*.pyc' -delete
sudo find -name __pycache__ -delete
docker run -it -v $(pwd):/tmp/app -w /tmp/app --rm painless/tox /bin/bash tox

