resource "google_folder" "playgrounds" {
  display_name = "plagrounds"
  parent       = "organizations/${var.org_id}"
}
