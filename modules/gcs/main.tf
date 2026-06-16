resource "google_storage_bucket" "raw" {
  name     = "${var.project_id}-raw"
  location = var.region
<<<<<<< HEAD

  versioning {
    enabled = true
  }
=======
  project  = var.project_id
>>>>>>> dev
}