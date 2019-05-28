#! /bin/bash

set -euo pipefail

repo=$(git rev-parse --show-toplevel)

for file in $(find $repo/kubernetes -maxdepth 1 -regex '.*.\(yaml\|yml\)'); do
  echo applying file $file
  kubectl apply -f $file
done
