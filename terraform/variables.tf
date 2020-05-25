variable "vault_token_path" {
  type	  = string
  default = "/secrets/root"
}

variable "kubernetes_cert_path" {
  type	  = string
  default = "/var/run/secrets/kubernetes.io/serviceaccount/ca.crt"
}
