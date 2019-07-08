# Cloud Agnostic Data Science Environments with Kubernetes

## Dependencies

Tools (supports all platforms)

 - [gcloud](https://cloud.google.com/sdk/)
 - [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
 - [helm](https://github.com/helm/helm/releases/tag/v2.14.1)

A [google cloud account](console.cloud.google.com) for this demo.

## Steps

1. Create a google cloud project `devops-knox` (2-3 minutes)

2. Provision nodes on gcloud. This may fail the first time since you
   will not have the "Kubernetes Engine API enabled" (10-20 minutes)

```shell
bash scripts/00-kubernetes-setup.sh
```

3. Install helm on kubernetes cluster (< 1 minute)

```shell
bash scripts/01-helm-setup.sh
```

4. Build managed jupyterlab docker image and deploy to docker hub (5 minutes)

```shell
docker build -t costrouc/devops-knox-jupyterlab:1 -f images/Dockerfile.jupyterlab .
docker push costrouc/devops-knox-jupyterlab:1
```

5. Install and upgrade helm applications: jupyterlab, prometheus, grafana, nginx ingress, and lets encrypt certificates (1-2 minutes) 

```shell
bash scripts/02-helm-installation.sh
```

6. Https certificates take about 10 minutes to be created and available


