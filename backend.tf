terraform {
  backend "gcs" {
    bucket  = "tf-state-${var.project_id}"
    prefix  = "gcp-dbt-infra"
  }
}