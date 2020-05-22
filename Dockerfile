FROM vault:1.4.2
MAINTAINER Alex Recker <alex@reckerfamily.com>
ADD server.hcl /vault/config/server.hcl
RUN chown vault:vault /vault/config/server.hcl
USER "vault"
WORKDIR "/vault"
ENV PS1 "\u@vault:\w\$ "
CMD ["vault", "server", "-config=/vault/config/vault.hcl"]
