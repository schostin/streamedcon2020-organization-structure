resource "google_folder" "production" {
  display_name = "production"
  parent       = "organizations/${var.org_id}"
}