terraform {
  backend "gcs" {
    bucket  = "tf-state-${var.project_id}"
    prefix  = "terraform"
  }
}