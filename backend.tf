terraform {
  cloud {
    organization = "my-org0"

    workspaces {
      name = "myworkspace"
    }
  }
}