locals {
  token_path = "/secrets/root"
}

provider "vault" {
  token	  = chomp(file(local.token_path))
}
