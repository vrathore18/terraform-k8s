resource "random_string" "documentdb_password" {
  length  = 16
  special = "false"
}
