provider "vault" {
  address = "http://vault.local"
  token	  = chomp(file(vars.vault_token_path))
}
