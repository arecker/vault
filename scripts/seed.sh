#!/bin/sh -e

log() {
    echo "seed.sh $1" 1>&2
}

aws() {
    cat <<EOF
[default]
aws_access_key_id = $(pass vault/aws-access-key)
aws_secret_access_key: $(pass vault/aws-secret-key)
EOF
}


log "applying secrets from password store"
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Secret
metadata:
  name: vault
  namespace: vault
data:
  root: $(pass vault/root | base64)
  aws: $(aws | base64)
  unseal: $(pass vault/unseal | base64)
EOF
