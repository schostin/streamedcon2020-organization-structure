resource "google_folder" "shared_services" {
  display_name = "shared-services"
  parent       = "organizations/${var.org_id}"
}