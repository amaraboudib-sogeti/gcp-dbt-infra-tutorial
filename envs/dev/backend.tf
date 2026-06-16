terraform {
  backend "gcs" {
    bucket  = "tf-state-gcp-dbt-dev"
    prefix  = "terraform/dev"
  }
}
