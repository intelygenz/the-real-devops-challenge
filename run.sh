#!/bin/bash

virtualenv -p python3 .venv
source .venv/bin/activate
pip install -r requirements.txt
export MONGO_URI=mongodb://appdb_admin:1234@localhost:27017/appdb
python app.py

