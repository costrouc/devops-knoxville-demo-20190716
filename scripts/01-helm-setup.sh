#!/usr/bin/env bash

## assumes the following commands are installed
# - kubectl
# - helm

# 1. create service account for helm
kubectl --namespace kube-system create serviceaccount tiller

# 2. give helm full permissions to manage cluster
kubectl create clusterrolebinding tiller \
        --clusterrole cluster-admin \
        --serviceaccount=kube-system:tiller

# 3. initialize helm on the server
helm init --service-account tiller --wait

# 4. secure tiller
kubectl patch deployment tiller-deploy \
        --namespace=kube-system \
        --type=json \
        --patch='[{"op": "add", "path": "/spec/template/spec/containers/0/command", "value": ["/tiller", "--listen=localhost:44134"]}]'

# 5. check should return client and server
echo "sleep 10 seconds to allow tiller to come up"
sleep 10
helm version
