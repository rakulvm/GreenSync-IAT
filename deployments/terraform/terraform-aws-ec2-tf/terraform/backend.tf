terraform {
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "rakul_org"
    workspaces {
      name = "Greensync_e2e"
    }
  }
}