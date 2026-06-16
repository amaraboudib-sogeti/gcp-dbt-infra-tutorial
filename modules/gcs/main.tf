resource "google_storage_bucket" "raw" {
  name     = "${var.project_id}-raw"
  location = var.region
  project  = var.project_id
}