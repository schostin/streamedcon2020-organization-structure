variable "project_id" {
  type        = string
  description = "The project id of the seed project."
}

variable "org_id" {
  type        = string
  description = "The organization id, under which folders get created"
}

variable "billing_account" {
  type        = string
  description = "The billing account id, used to associate billing with created projects."
}

variable "github_token" {
  type        = string
  description = "The github token to authenticate against the Github API"
}

variable "github_owner" {
  type        = string
  description = "The github organization or user under which the repository will be created"
}
