resource "google_folder" "staging" {
  display_name = "staging"
  parent       = "organizations/${var.org_id}"
}
