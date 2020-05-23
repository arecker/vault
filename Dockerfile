FROM alpine:3
MAINTAINER Alex Recker <alex@reckerfamily.com>

RUN addgroup --gid 1001 vault && adduser --home /home/vault --uid 1001 -S -G vault vault
RUN apk --update add bash curl terraform
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
