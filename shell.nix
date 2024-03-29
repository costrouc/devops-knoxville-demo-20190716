{ pkgs ? import <nixpkgs> { } }:

pkgs.mkShell {
  buildInputs = [ pkgs.kubernetes-helm pkgs.kubectl ];

  shellHook = ''
    export GCLOUD_PROJECT=devops-knox
    export GCLOUD_ZONE=us-east1-c
    export GCLOUD_CLUSTER=devops-knox
    export GCLOUD_ACCOUNT=costrouchov@quansight.com

    # I use gopass https://github.com/gopasspw/gopass
    # for my secret management (gpg + git)
    export GRAFANA_PASSWORD=$(gopass personal/201907-devops-knox grafana_password)
    export JUPYTER_SECRET_TOKEN=$(gopass personal/201907-devops-knox jupyter_secret_token)
    export GITHUB_CLIENT_ID=$(gopass personal/201907-devops-knox github_client_id)
    export GITHUB_CLIENT_SECRET=$(gopass personal/201907-devops-knox github_client_secret)
  '';
}
