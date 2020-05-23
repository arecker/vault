#!/bin/bash -e

log() {
    echo "entry.sh: $1" 1>&2
}

show_versions() {
    log "$(vault version), $(terraform version)"
}

show_versions
log "VAULT_ADDR=\"$VAULT_ADDR\" SUBCOMMAND=\"$1\""

case "$1" in
    "console" )
	log "launching interactive console"
	bash -l
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
