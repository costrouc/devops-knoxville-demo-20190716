#!/usr/bin/env bash

## assumes the following commands are installed
# - gcloud
# - kubectl

# ===== options ======
export DEFAULT_MACHINETYPE=n1-standard-1
export DEFAULT_NODES=2

export USER_MACHINETYPE=n1-standard-4

export WORKER_DISK_SIZE=10GB
export CPU_WORKER_MACHINETYPE=n1-standard-4


# 1. provision kubernetes cluster
gcloud container clusters create \
  --machine-type $DEFAULT_MACHINETYPE \
  --num-nodes $DEFAULT_NODES \
  --zone $GCLOUD_ZONE \
  --cluster-version latest \
  $GCLOUD_CLUSTER


# 2. give credentials to `kubectl` command
gcloud container clusters get-credentials $GCLOUD_CLUSTER \
       --zone $GCLOUD_ZONE \
       --project $GCLOUD_PROJECT


# 3. give $ACCOUNT admin priviliges
kubectl create clusterrolebinding cluster-admin-binding \
  --clusterrole=cluster-admin \
  --user=$GCLOUD_ACCOUNT


# 4. dynamic cluster allocation for jupyter hub notebooks
gcloud beta container node-pools create user-pool \
  --machine-type $USER_MACHINETYPE \
  --num-nodes 0 \
  --enable-autoscaling \
  --min-nodes 0 \
  --max-nodes 2 \
  --node-labels hub.jupyter.org/node-purpose=user \
  --node-taints hub.jupyter.org_dedicated=user:NoSchedule \
  --zone $GCLOUD_ZONE \
  --cluster $GCLOUD_CLUSTER


# 5. dynamic cluster allocation for premtible workers (cpu)
gcloud beta container node-pools create cpu-worker-pool \
  --machine-type $CPU_WORKER_MACHINETYPE \
  --disk-size $WORKER_DISK_SIZE \
  --preemptible \
  --num-nodes 0 \
  --enable-autoscaling \
  --min-nodes 0 \
  --max-nodes 5 \
  --node-labels hub.jupyter.org/node-purpose=cpu-worker \
  --node-taints hub.jupyter.org_dedicated=cpu-worker:NoSchedule \
  --zone $GCLOUD_ZONE \
  --cluster $GCLOUD_CLUSTER

# 6. check should return two nodes
kubectl get nodes
