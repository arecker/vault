#!/bin/sh -e

log() {
    echo "seed.sh $1" 1>&2
}

# cat <<EOF | kubectl apply -f -
cat <<EOF
apiVersion: v1
kind: Secret
metadata:
  name: test-secret
data:
  token: $(pass vault/token)
  unseal: |
$(pass vault/unseal | pr -t -o 4)
EOF
