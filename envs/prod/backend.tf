terraform {
  backend "gcs" {
    bucket  = "tf-state-gcp-dbt-prod"
    prefix  = "terraform/dev"
  }
}
