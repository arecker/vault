locals {
  token_path	    = "/secrets/root"
  aws_creds_path    = "/secrets/aws"
}

terraform {
  backend "local" {
    path = "/data/config.tfstate"
  }
}

provider "vault" {
  token = chomp(file(local.token_path))
}

resource "vault_mount" "kv" {
  path	  = "secret/"
  type	  = "kv"
  options = {
    version = 2
  }
}
