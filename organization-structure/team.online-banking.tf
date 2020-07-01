locals {
  iam_roles_per_folder = toset([
    "roles/resourcemanager.folderAdmin",
    "roles/compute.networkAdmin",
    "roles/compute.xpnAdmin",
    "roles/iam.securityAdmin",
    "roles/iam.serviceAccountAdmin",
    "roles/resourcemanager.folderAdmin",
    "roles/resourcemanager.projectCreator",
    "roles/resourcemanager.projectDeleter",
    "roles/resourcemanager.projectIamAdmin",
    "roles/resourcemanager.projectMover",
  ])
  iam_roles_in_organization = toset([
    "roles/billing.user",
    "roles/resourcemanager.organizationViewer",
  ])
}

resource "google_service_account" "online_banking" {
  account_id   = "online-banking-terraform"
  display_name = "Online Banking Terraform"
  description  = "Online Banking Terraform Service Account used to create folders and resources within the different folders."
}

resource "google_folder" "online_banking_playgrounds" {
  display_name = "online-banking"
  parent       = google_folder.playgrounds.name
}

resource "google_folder_iam_binding" "online_banking_playgrounds" {
  for_each = local.iam_roles_per_folder
  folder   = google_folder.playgrounds.name
  role     = each.value

  members = [
    "serviceAccount:${google_service_account.online_banking.email}",
  ]
}

resource "google_organization_iam_member" "binding" {
  for_each = local.iam_roles_in_organization
  org_id   = var.org_id
  role     = each.value
  member   = "serviceAccount:${google_service_account.online_banking.email}"
}

resource "google_folder" "online_banking_development" {
  display_name = "online-banking"
  parent       = google_folder.development.name
}

resource "google_folder_iam_binding" "online_banking_development" {
  for_each = local.iam_roles_per_folder
  folder   = google_folder.development.name
  role     = each.value

  members = [
    "serviceAccount:${google_service_account.online_banking.email}",
  ]
}

resource "google_folder" "online_banking_staging" {
  display_name = "online-banking"
  parent       = google_folder.staging.name
}

resource "google_folder_iam_binding" "online_banking_staging" {
  for_each = local.iam_roles_per_folder
  folder   = google_folder.staging.name
  role     = each.value

  members = [
    "serviceAccount:${google_service_account.online_banking.email}",
  ]
}

resource "google_folder" "online_banking_production" {
  display_name = "online-banking"
  parent       = google_folder.production.name
}

resource "google_folder_iam_binding" "online_banking_production" {
  for_each = local.iam_roles_per_folder
  folder   = google_folder.production.name
  role     = each.value

  members = [
    "serviceAccount:${google_service_account.online_banking.email}",
  ]
}

resource "random_string" "online_banking_prefix" {
  length  = 8
  special = false
  number  = false
  upper = false
}

module "online_banking_bucket" {
  source          = "terraform-google-modules/cloud-storage/google"
  version         = "1.6.0"
  project_id      = var.project_id
  names           = ["online-banking"]
  prefix          = random_string.online_banking_prefix.result
  location        = "EU"
  set_admin_roles = true
  admins          = ["service-account:${google_service_account.online_banking.email}"]
  versioning = {
    online-banking = true
  }
}

module "online_banking_repository" {
  source = "github.com/sebastianneb-streamedcon2020/terraform-module-github-actions-gcloud?ref=v1.4.0"

  project_id                 = var.project_id
  org_id                     = var.org_id
  billing_account            = var.billing_account
  domain                     = var.domain
  name                       = "team-online-banking"
  description                = "Repository to manage all online-banking projects and folders"
  bucket                     = module.online_banking_bucket.name
  service_account_email      = google_service_account.online_banking.email
  github_token               = var.github_token
  github_owner               = var.github_owner
  github_template_owner      = var.github_owner
  github_template_repository = var.github_template_repository
}
