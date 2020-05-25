#!/usr/bin/env bash

log() {
    echo "install-hashicorp-nonsense.sh: $1" 1>&2
}

print_arch() {
    apk --print-arch
}

setup_temp() {
    mkdir -p /tmp/build
    cd /tmp/build
}

teardown_temp() {
    cd /tmp
    rm -rf /tmp/build
}

install_terraform() {
    local URL="https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_${ARCH}.zip"
    log "downloading $URL"
    wget "$URL"
    local ZIP_PATH="terraform_${TERRAFORM_VERSION}_linux_${ARCH}.zip"
    log "extracting $ZIP_PATH"
    unzip -d /bin "$ZIP_PATH"
    log "$(/bin/terraform version)"
}

install_vault() {
    local URL="https://releases.hashicorp.com/vault/${VAULT_VERSION}/vault_${VAULT_VERSION}_linux_${ARCH}.zip"
    log "downloading $URL"
    wget "$URL"
    local ZIP_PATH="vault_${VAULT_VERSION}_linux_${ARCH}.zip"
    log "extracting $ZIP_PATH"
    unzip -d /bin "$ZIP_PATH"
    log "$(/bin/vault version)"
}

case "$(print_arch)" in 
    armhf) ARCH='arm' ;;
    aarch64) ARCH='arm64' ;;
    x86_64) ARCH='amd64' ;;
    x86) ARCH='386' ;;
    *) log "unsupported architecture $(print_arch)"
esac

log "detected $ARCH"

log "setting up tempdir"
setup_temp

case "$1" in
    "terraform")
	log "installing terraform $TERRAFORM_VERSION"
	install_terraform
	;;
    "vault")
	log "installing vault $VAULT_VERSION"
	install_vault
	;;
    *)
	log "unknown option $1"
	exit 1
	;;
esac

log "tearing down tempdir"
teardown_temp
