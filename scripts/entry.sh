#!/bin/bash -e

log() {
    echo "entry.sh: $1" 1>&2
}

show_versions() {
    log "$(vault version), $(terraform version)"
}

fetch_status_code() {
    curl -s -L -o /dev/null -w "%{http_code}" "$1"
}

wait_for_up() {
    log "waiting for vault to come up..."
    while true; do
	local status="$(fetch_status_code $VAULT_ADDR)"
	[[ "$status" != "200" ]] || break
	log "vault returned $status, waiting..."
	sleep 2
    done
    log "vault is up!"
}

wait_for_unseal() {
    log "waiting for vault to be unsealed..."
    while true; do
	local status="$(fetch_status_code $VAULT_ADDR/v1/sys/health)"
	[[ "$status" != "200" ]] || break
	log "vault returned $status, waiting..."
	sleep 2
    done
    log "vault is unsealed!"
}

check_seal() {
    local status="$(fetch_status_code $VAULT_ADDR/v1/sys/health)"
    case "$status" in
	"503" )
	    log "status: $status"
	    log "attempting to unseal vault"
	    unseal
	    ;;
	* )
	    log "status: $status"
	    ;;
    esac
}

unseal() {
    for token in $(cat "/secrets/unseal"); do
	vault operator unseal "$token"
    done
}

show_versions
log "VAULT_ADDR=\"$VAULT_ADDR\" SUBCOMMAND=\"$1\""

case "$1" in
    "console" )
	log "launching interactive console"
	bash -l
	;;
    "terraform" )
	wait_for_up
	wait_for_unseal
	log "running terraform"
	cd /home/vault/terraform
	terraform init
	terraform apply -auto-approve
	log "terraform finished, sleeping"
	while true; do
	    sleep 1
	done
	;;
    "unseal" )
	wait_for_up
	log "running unsealer"
	while true; do
	    check_seal
	    sleep 5
	done
	;;
    "server" )
	log "launching server"
	vault server -config=/home/vault/server.hcl
	;;
    "" )
	log "empty subcommand, nothing to do!"
	;;
    * )
	log "unknown subcommand \"$1\""
	exit 1
	;;
esac
