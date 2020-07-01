terraform {
  required_version = "0.12.28"
  required_providers {
    github = "2.9.0"
    google = "3.28.0"
  }
}

provider "google" {
  project = var.project_id
}

provider "github" {
  token = var.github_token
  owner = var.github_owner
}
