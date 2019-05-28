#! /bin/bash

set -euxo pipefail
kubectl delete deployments mongo flask 2> /dev/null
kubectl delete services mongo flask 2> /dev/null
set +x

until [ $(kubectl get pods 2>/dev/null | wc -l ) = 0 ];
do
  echo termination in progress...
  sleep 2
done
