#!/usr/bin/env bash

# Helm initial installation of services
# helm configuration in `helm-config/<service-name>.yaml`

# add repositories and update
helm repo add incubator http://storage.googleapis.com/kubernetes-charts-incubator
helm repo add jupyterhub https://jupyterhub.github.io/helm-chart/
helm repo update


# ================== network ====================
# kube-lego
helm upgrade --install kube-lego stable/kube-lego \
     --namespace ingress \
     --version=0.4.2 \
     --values helm-config/kube-lego.yaml

# nginx-ingress
helm upgrade --install nginx-ingress stable/nginx-ingress \
     --namespace ingress \
     --version=1.6.17 \
     --values helm-config/nginx-ingress.yaml

# =============== monitoring ==================
# prometheus
helm upgrade --install prometheus stable/prometheus \
     --namespace monitoring \
     --version=8.11.4 \
     --values helm-config/prometheus.yaml


# grafana
# create grafana password
kubectl create secret generic "grafana-password" \
        --namespace monitoring  \
        --from-literal=admin-user=admin \
        --from-literal=admin-password=$GRAFANA_PASSWORD

helm upgrade --install grafana stable/grafana \
     --namespace monitoring \
     --version=3.4.2 \
     --values helm-config/grafana.yaml

# ============= interactivate development ==============
# jupyterhub
# allow users to schedule pods
kubectl apply -f kube-config/jupyterlab-permissions.yaml

helm upgrade --install jupyterhub jupyterhub/jupyterhub \
  --namespace jupyterhub  \
  --version=0.8.2 \
  --set proxy.secretToken="$JUPYTER_SECRET_TOKEN",auth.github.clientId="$GITHUB_CLIENT_ID",auth.github.clientSecret="$GITHUB_CLIENT_SECRET" \
  --values helm-config/jupyterhub.yaml
