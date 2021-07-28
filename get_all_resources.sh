#!/bin/bash

# chmod +x get_all_resources.sh

OUTPUT=$(kubectl api-resources -o name)
DIR="./resources"

if [[ -d $DIR ]]; then
    echo "Found Directory -- Deleting ${DIR}"
    rm -rf $DIR
fi

mkdir resources
cd resources

for a in $OUTPUT
do
    echo $a | cut -d'.' -f1
    kubectl get $a --all-namespaces --show-labels -o wide > ${a}.csv
done
cd ..
