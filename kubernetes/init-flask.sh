 #!/bin/bash

FLASK_HOME=$(pwd)

ACTION=$1
NAMESPACE=$2
FILES=(mongodb-secret.yaml mongodb-service.yaml mongodb-deployment.yaml webapp-service.yaml webapp-deployment.yaml)

KUBECTL_BIN="$(which kubctl)"

if [ -z "$KUBECTL_BIN" ];
then
    echo "Kubectl is not installed."
    exit 1
fi

if [ "${ACTION}" == "create" ] || [ "${ACTION}" == "delete" ];
then
    for FILE in ${FILES[@]}; do
        $KUBECTL_BIN $ACTION -n ${NAMESPACE:-default} -f $FLASK_HOME/$FILE
    done
    exit 0
else
    echo "Usage: $0 [create|delete] <default>"
    echo "  Actions: create or delete"
    echo "  Namespace: Namespace in which you want to create the resources, by default: default"
    exit 1
fi
