locals {
  cert_path = "/secrets/cert.pem" # TODO: service account
}

resource "vault_auth_backend" "kubernetes" {
  type = "kubernetes"
}

resource "vault_kubernetes_auth_backend_config" "config" {
  backend            = "${vault_auth_backend.kubernetes.path}"
  kubernetes_host    = "https://farm-0:6443"
  kubernetes_ca_cert = file(local.cert_path)
}

resource "vault_policy" "chorebot" {
  name = "chorebot"

  policy = <<EOT
path "secret/data/slack/reckerfamily/webhook" {
  capabilities = ["read"]
}
EOT
}

resource "vault_kubernetes_auth_backend_role" "chorebot" {
  backend                          = vault_auth_backend.kubernetes.path
  role_name                        = "chorebot"
  bound_service_account_names      = ["default"]
  bound_service_account_namespaces = ["default"]
  token_policies                   = ["chorebot"]
}

resource "vault_policy" "hub" {
  name = "hub"

  policy = <<EOT
path "secret/data/hub" {
  capabilities = ["read"]
}
EOT
}

resource "vault_kubernetes_auth_backend_role" "hub" {
  backend                          = vault_auth_backend.kubernetes.path
  role_name                        = "hub"
  bound_service_account_names      = ["default"]
  bound_service_account_namespaces = ["hub"]
  token_policies                   = ["hub"]
}

resource "vault_policy" "reckerbot" {
  name = "reckerbot"

  policy = <<EOT
path "secret/data/reckerbot" {
  capabilities = ["read"]
}
EOT
}

resource "vault_kubernetes_auth_backend_role" "reckerbot" {
  backend                          = vault_auth_backend.kubernetes.path
  role_name                        = "reckerbot"
  bound_service_account_names      = ["default"]
  bound_service_account_namespaces = ["reckerbot"]
  token_policies                   = ["reckerbot"]
}

resource "vault_policy" "wallpaper" {
  name = "wallpaper"

  policy = <<EOT
path "secret/data/wallpaper" {
  capabilities = ["read"]
}
EOT
}

resource "vault_kubernetes_auth_backend_role" "wallpaper" {
  backend                          = vault_auth_backend.kubernetes.path
  role_name                        = "wallpaper"
  bound_service_account_names      = ["default"]
  bound_service_account_namespaces = ["wallpaper"]
  token_policies                   = ["wallpaper"]
}
