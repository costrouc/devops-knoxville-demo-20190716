# # set environment variables
# export GCLOUD_PROJECT="<matching project name>"
# export GCLOUD_ZONE=us-east1-c
# export GCLOUD_CLUSTER=devops-knox
# export GCLOUD_ACCOUNT="<account email>"
# export GRAFANA_PASSWORD="..."
# export JUPYTER_SECRET_TOKEN="<generate via `openssl rand -hex 32`>"
# # create github oauth application
# # https://developer.github.com/apps/building-oauth-apps/
# export GITHUB_CLIENT_ID="..."
# export GITHUB_CLIENT_SECRET="..."

# deploy kubernetes cluster
bash 00-kubernetes-setup.sh

# setup helm/tiller
bash 01-helm-setup.sh

# build docker image and push to docker hub
docker build -t costrouc/devops-knox-jupyterlab:1 -f images/Dockerfile.jupyterlab .
docker push costrouc/devops-knox-jupyterlab:1

# helm install applications
bash 02-helm-installation.sh
