#!/bin/sh

if [[ -z "${MONGO_URI}" ]]; then
    echo "MONGO_URI is set to the empty string. Configuring MONGO_URI variable"
    if [ -z "${MONGODB_DATABASE}" ] || [ -z "${MONGODB_USERNAME}" ] || [ -z "${MONGODB_PASSWORD_FILE}" ] || [ -z "${MONGODB_HOSTNAME}" ] || [ -z "${MONGODB_PORT}" ]; then
    echo -e "\nOne or more variables are undefined. Please configure: MONGODB_DATABASE, MONGODB_USERNAME, MONGODB_PASSWORD_FILE, MONGODB_DATABASE, MONGODB_PORT"

    echo -e "\n######## Current Env Variables ########"
    echo  "MONGODB_DATABASE: " ${MONGODB_DATABASE}
    echo  "MONGODB_USERNAME: " ${MONGODB_USERNAME}
    echo  "MONGODB_PASSWORD_FILE: " ${MONGODB_PASSWORD_FILE}
    echo  "MONGODB_DATABASE: " ${MONGODB_HOSTNAME}
    echo  "MONGODB_PORT: " ${MONGODB_PORT}    
    echo "#######################################"    
    exit 1
    fi

    export MONGO_URI=mongodb://${MONGODB_USERNAME}:$(cat "$MONGODB_PASSWORD_FILE")@${MONGODB_HOSTNAME}:${MONGODB_PORT}/${MONGODB_DATABASE}
    echo "MONGO_URI congifured"

else
    echo "MONGO_URI already congifured"
fi

python app.py
