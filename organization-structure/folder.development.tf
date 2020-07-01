resource "google_folder" "development" {
  display_name = "development"
  parent       = "organizations/${var.org_id}"
}
