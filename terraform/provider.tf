provider "vault" {
  address = "http://vault.local"
  token	  = chomp(file(var.vault_token_path))
}
