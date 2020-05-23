FROM alpine:3
MAINTAINER Alex Recker <alex@reckerfamily.com>

RUN apk --update add bash curl

RUN addgroup vault && adduser --home /home/vault --uid 1001 -S -G vault vault

COPY --from=vault:latest /bin/vault /usr/local/bin/vault
COPY --from=hashicorp/terraform:latest /bin/terraform /usr/local/bin/terraform
COPY scripts/entry.sh /usr/local/bin/entry.sh
ADD server.hcl /home/vault/server.hcl
RUN chown vault:vault /home/vault/server.hcl

USER vault
WORKDIR /home/vault
ENV VAULT_ADDR "http://127.0.0.1:8200"
ENTRYPOINT ["/usr/local/bin/entry.sh"]
CMD ["console"]
