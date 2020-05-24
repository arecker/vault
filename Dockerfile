FROM alpine:3
MAINTAINER Alex Recker <alex@reckerfamily.com>

ARG UID="1001"
ARG GID="1001"
ARG TERRAFORM_VERSION="0.12.25"
ARG VAULT_VERSION="1.4.2"

RUN addgroup --gid "${GID}" vault && adduser --home /home/vault --uid "${UID}" -S -G vault vault
RUN apk --update add bash curl

COPY --from=vault:latest /bin/vault /usr/local/bin/vault

ADD scripts/entry.sh /usr/local/bin/entry.sh
ADD server.hcl /home/vault/server.hcl
ADD terraform /home/vault/terraform
RUN chown -R vault:vault /home/vault

USER vault
WORKDIR /home/vault
ENV VAULT_ADDR "http://127.0.0.1:8200"
ENTRYPOINT ["/usr/local/bin/entry.sh"]
CMD ["console"]
