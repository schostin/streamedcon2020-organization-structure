locals {
  iam_roles_per_folder = toset([
    "roles/resourcemanager.folderAdmin"
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
