FROM alpine:3
MAINTAINER Alex Recker <alex@reckerfamily.com>

ARG TERRAFORM_VERSION="0.12.25"
ARG VAULT_VERSION="1.4.2"

RUN addgroup --gid 1001 vault && adduser --home /home/vault --uid 1001 -S -G vault vault
RUN apk --update add bash curl

RUN \
	set -eux; \
	apkArch="$(apk --print-arch)"; \
	case "$apkArch" in \
	armhf) ARCH='arm' ;; \
	armv7) ARCH='arm' ;; \
	aarch64) ARCH='arm' ;; \
	x86_64) ARCH='amd64' ;; \
	x86) ARCH='386' ;; \
	*) echo >&2 "error: unsupported architecture: $apkArch"; exit 1 ;; \
	esac && \
	mkdir -p /tmp/build && \
	cd /tmp/build && \
	wget https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_${ARCH}.zip && \
        wget https://releases.hashicorp.com/vault/${VAULT_VERSION}/vault_${VAULT_VERSION}_linux_${ARCH}.zip && \
	unzip -d /bin terraform_${TERRAFORM_VERSION}_linux_${ARCH}.zip && \
	unzip -d /bin vault_${VAULT_VERSION}_linux_${ARCH}.zip && \
	rm -rf /tmp/build

ADD scripts/entry.sh /usr/local/bin/entry.sh
ADD server.hcl /home/vault/server.hcl
ADD terraform /home/vault/terraform
RUN chown -R vault:vault /home/vault

USER vault
WORKDIR /home/vault
ENV VAULT_ADDR "http://127.0.0.1:8200"
ENTRYPOINT ["/usr/local/bin/entry.sh"]
CMD ["console"]
